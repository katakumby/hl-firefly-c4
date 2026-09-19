"""Regression tests for provenance, publication, evidence transactions and presentation."""
from concurrent.futures import ThreadPoolExecutor
from contextlib import ExitStack
from copy import deepcopy
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tarfile
import tempfile
import unittest
from unittest.mock import patch
from architecture_validation import audit
from artifact_store import atomic_json, file_lock, new_run, publish, read_status, resolve_run, retain_runs, successful_run
from evidence_store import SnapshotStore, REQUIRED_BINDINGS, verify_inventory
from presentation_catalog import normalize_presentation, presentation_difference
from refresh_evidence import Refresher, refresh
from workspace_catalog import normalize
from workspace_dependencies import dependencies, derive_provenance, identity_conflicts, workspace_profile
from workspace_paths import ROOT, BUILD, ARCHITECTURE, SHARED, REFERENCE, SOURCES
from validate_workspaces import validate_workspaces, source_snapshot
from test_workspace_validation import focused_context


def inventory_fixture():
    names = {name for pair in REQUIRED_BINDINGS for name in pair}
    return {'repositories': {key: {'repository': 'example/' + key, 'commit': 'a' * 40,
            'url': 'https://example/' + key, 'documents': {}, 'paths': []} for key in names},
            'pages': {}, 'embedded_dependencies': [{'runtime': owner, 'library': library,
                'version': 'v1.0.0', 'commit': 'a' * 40, 'evidence': 'https://example/' + owner}
                for owner, library in sorted(REQUIRED_BINDINGS)]}


def archive_fixture(files):
    buffer = io.BytesIO()
    with tarfile.open(fileobj=buffer, mode='w:gz') as archive:
        for name, content in files.items():
            member = tarfile.TarInfo('repo/' + name)
            member.size = len(content)
            archive.addfile(member, io.BytesIO(content))
    return buffer.getvalue()


class ProvenanceRules(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.reference = json.loads((successful_run(REFERENCE) / 'workspace.json').read_text(encoding='utf-8-sig'))
        cls.ignition = json.loads((successful_run(ARCHITECTURE / 'initiatives/ignition/workspace.dsl') / 'workspace.json').read_text(encoding='utf-8-sig'))
        cls.sources = json.loads(SOURCES.read_text())

    def focused(self, raw, catalog=None, context=None):
        return audit(raw, catalog or normalize(raw), self.sources, False, context or focused_context(self.reference))

    def test_hidden_local_element_cannot_claim_inherited_exception(self):
        raw = deepcopy(self.ignition)
        raw['model']['softwareSystems'].append({'id': 'review-local', 'name': 'Local proposal',
            'description': 'Local responsibility', 'properties': {'architecture.id': 'local_proposal',
            'evidence': 'Proposed architecture', 'structurizr.inspection.model.element.noview': 'info'}})
        result = self.focused(raw)
        self.assertFalse(result['passed'])
        self.assertTrue(any('narrowly scoped' in e for e in result['errors']))
        self.assertIn('Every initiative-local element appears in a view', result['errors'])

    def test_wrong_prefix_and_duplicate_selections_fail(self):
        catalog = normalize(self.ignition)
        view = deepcopy(normalize(self.reference)['views'][0])
        view['key'] = 'unprefixed-a'
        duplicate = deepcopy(view)
        duplicate['key'] = 'unprefixed-b'
        catalog['views'] += [view, duplicate]
        result = self.focused(self.ignition, catalog)
        self.assertFalse(result['passed'])
        self.assertIn('No duplicate view selections within one scope', result['errors'])
        self.assertTrue(any('view prefix' in e for e in result['errors']))

    def test_variant_accepts_inherited_keys_and_its_own_prefix(self):
        catalog = normalize(self.ignition)
        context = focused_context(self.reference) | {'prefix': 'ignition-interim-',
                                                    'inherited_views': {'ignition-dapp-platform-context'}}
        view = deepcopy(normalize(self.reference)['views'][0])
        view['key'] = 'ignition-interim-reference'
        catalog['views'].append(view)
        self.assertTrue(self.focused(self.ignition, catalog, context)['passed'])
        view['key'] = 'ignition-reference'
        self.assertFalse(self.focused(self.ignition, catalog, context)['passed'])

    def test_placeholder_is_not_transferable_to_another_epic(self):
        context = focused_context(self.reference) | {'placeholder': False, 'prefix': 'other-'}
        result = self.focused(self.ignition, context=context)
        self.assertFalse(result['passed'])
        self.assertIn('DApp proposal belongs only to ignition and its variants', result['errors'])

    def test_identity_reuse_and_collision_across_origins(self):
        parent = derive_provenance(self.reference, SHARED)
        one = derive_provenance(self.ignition, 'ignition', parent)
        variant = derive_provenance(self.ignition, 'ignition/variant', one)
        self.assertEqual({}, identity_conflicts({'ignition': one, 'variant': variant}))
        other = derive_provenance(self.ignition, 'another-epic', parent)
        conflicts = identity_conflicts({'ignition': one, 'another-epic': other})
        self.assertEqual({'ignition', 'another-epic'}, set(conflicts))

    def test_shared_export_default_views_are_not_inherited_authoring(self):
        provenance = derive_provenance(self.reference, SHARED)
        self.assertEqual(set(), provenance['views'])

    def test_shared_and_cross_epic_dependencies_rejected(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            architecture = Path(temporary)
            a = architecture / 'initiatives/a/workspace.dsl'
            b = architecture / 'initiatives/b/workspace.dsl'
            a.parent.mkdir(parents=True)
            b.parent.mkdir(parents=True)
            b.write_text('workspace {}')
            a.write_text('workspace extends ../b/workspace.dsl {}')
            shared = architecture / 'model.dsl'
            shared.write_text('workspace {\n !include initiatives/b/workspace.dsl\n}')
            with patch('workspace_dependencies.ARCHITECTURE', architecture):
                for path in (a, shared):
                    with self.assertRaisesRegex(ValueError, 'cross-initiative'):
                        dependencies(path)

    def test_comments_do_not_create_dependencies(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            path = Path(temporary) / 'workspace.dsl'
            path.write_text('/*\n !include absent.dsl\n*/\nworkspace {\n // !include absent.dsl\n}\n')
            self.assertEqual({path.resolve()}, dependencies(path))


class PublicationRules(unittest.TestCase):
    def publish_fixture(self, directory, value, passed=True):
        run = new_run(directory)
        atomic_json(run / 'workspace.json', {'generation': value})
        atomic_json(run / 'model-catalog.json', {'generation': value})
        publish(directory, run, {'workspace': 'fixture', 'passed': passed,
                                 'completed_at': str(value), 'source_sha256': str(value)})
        return run

    def test_failed_run_keeps_coherent_success(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            directory = Path(temporary)
            success = self.publish_fixture(directory, 1)
            failure = self.publish_fixture(directory, 2, False)
            self.assertEqual(success, resolve_run(directory)[0])
            self.assertEqual(failure, resolve_run(directory, False)[0])
            self.assertEqual({'generation': 1}, json.loads((resolve_run(directory)[0] / 'model-catalog.json').read_text()))

    def test_reader_never_observes_mixed_artifacts(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            directory = Path(temporary)
            self.publish_fixture(directory, 0)
            def reader():
                for _ in range(80):
                    run, _ = resolve_run(directory)
                    a = json.loads((run / 'workspace.json').read_text())
                    b = json.loads((run / 'model-catalog.json').read_text())
                    self.assertEqual(a, b)
            with ThreadPoolExecutor(max_workers=2) as pool:
                future = pool.submit(reader)
                for value in range(1, 12):
                    self.publish_fixture(directory, value)
                future.result()

    def test_cross_process_lock_and_release(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            lock = Path(temporary) / '.lock'
            code = 'import sys;sys.path.insert(0,sys.argv[1]);from artifact_store import file_lock\nwith file_lock(sys.argv[2]): pass'
            arguments = [sys.executable, '-B', '-c', code, str(ARCHITECTURE / 'scripts'), str(lock)]
            with file_lock(lock):
                self.assertNotEqual(0, subprocess.run(arguments, capture_output=True).returncode)
            self.assertEqual(0, subprocess.run(arguments, capture_output=True).returncode)

    def test_retention_protects_preview_success_pending_and_history(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            directory = Path(temporary)
            runs = [self.publish_fixture(directory, n, n == 1) for n in range(8)]
            pending = new_run(directory)
            historical = directory / 'workspace.json'
            historical.write_text('historical')
            retain_runs(directory, {runs[0].name})
            self.assertTrue(runs[0].exists())
            self.assertTrue(runs[1].exists())
            self.assertFalse(runs[2].exists())
            self.assertTrue(all(p.exists() for p in runs[3:]))
            self.assertTrue(pending.exists())
            self.assertEqual('historical', historical.read_text())


class EvidenceTransactions(unittest.TestCase):
    def test_missing_caches_allowed_but_corruption_rejected(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            root = Path(temporary)
            inventory = inventory_fixture()
            record = SnapshotStore(root).document(b'original', 'https://example/evidence')
            inventory['pages']['sample'] = record
            self.assertTrue(verify_inventory(inventory, root)['passed'])
            (root / record['cache']).write_bytes(b'corrupt')
            self.assertFalse(verify_inventory(inventory, root)['passed'])
            (root / record['cache']).unlink()
            self.assertTrue(verify_inventory(inventory, root)['passed'])
            self.assertFalse(verify_inventory(inventory, root, require_cached=True)['passed'])

    def test_revisions_do_not_share_removed_files(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            store = SnapshotStore(temporary)
            a = store.archive('repo', 'a' * 40, archive_fixture({'old.go': b'old', 'keep.go': b'v1'}), 'https://example/a')
            b = store.archive('repo', 'b' * 40, archive_fixture({'keep.go': b'v2'}), 'https://example/b')
            self.assertTrue((Path(temporary) / a['directory'] / 'old.go').exists())
            self.assertFalse((Path(temporary) / b['directory'] / 'old.go').exists())
            self.assertEqual(b'v2', (Path(temporary) / b['directory'] / 'keep.go').read_bytes())

    def test_archive_path_escape_rejected(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            with self.assertRaisesRegex(ValueError, 'Unsafe archive'):
                SnapshotStore(temporary).archive('repo', 'a' * 40, archive_fixture({'../escape.go': b'bad'}), 'https://example')
            self.assertFalse((Path(temporary) / 'escape.go').exists())

    def test_partial_dependency_refresh_preserves_other_owners(self):
        inventory = inventory_fixture()
        original = deepcopy(inventory['embedded_dependencies'])
        worker = Refresher(inventory, fetch=lambda url: self.fail('Unexpected network call: ' + url))
        worker.pinned_document = lambda owner, name: (
            b'{"packages":{"node_modules/@hyperledger/firefly-sdk":{"version":"1.3.0"}}}'
            if owner == 'sandbox' else b'github.com/hyperledger-firefly/transaction-manager v1.3.20',
            {'url': 'https://example/' + owner})
        worker.repository = lambda key, repository, ref: inventory['repositories'][key]
        worker.bindings({'tezosconnect', 'sandbox'})
        self.assertEqual(5, len(inventory['embedded_dependencies']))
        unaffected = lambda ds: [d for d in ds if d['runtime'] not in ('tezosconnect', 'sandbox')]
        self.assertEqual(unaffected(original), unaffected(inventory['embedded_dependencies']))
        self.assertTrue(verify_inventory(inventory, ROOT)['passed'])

    def test_static_refresh_recomputes_all_five_bindings(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            inventory = inventory_fixture()
            worker = Refresher(inventory, temporary, fetch=lambda url: b'document snapshot')
            worker.repository = lambda key, repository, ref='HEAD': inventory['repositories'].setdefault(
                key, {'repository': repository, 'commit': 'a' * 40, 'documents': {}, 'paths': []})
            def pinned(owner, name):
                if owner == 'sandbox':
                    raw = b'{"packages":{"node_modules/@hyperledger/firefly-sdk":{"version":"1.3.0"}}}'
                else:
                    raw = b'github.com/hyperledger-firefly/transaction-manager v1.5.4\ngithub.com/hyperledger-firefly/signer v1.2.2\ngithub.com/hyperledger-firefly/common v1.6.3'
                return raw, {'url': 'https://example/' + owner}
            worker.pinned_document = pinned
            worker.static()
            self.assertEqual(REQUIRED_BINDINGS, {(d['runtime'], d['library']) for d in inventory['embedded_dependencies']})
            self.assertEqual(5, len(inventory['embedded_dependencies']))
            self.assertTrue(verify_inventory(inventory, temporary)['passed'])

    def transaction(self, updater):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            root = Path(temporary)
            path = root / 'architecture/references/sources.json'
            atomic_json(path, inventory_fixture())
            original = path.read_bytes()
            with self.assertRaises((ValueError, RuntimeError)):
                refresh(root=root, inventory_path=path, updater=lambda inventory: updater(root, path, inventory))
            return path.read_bytes(), original

    def test_missing_binding_cannot_publish(self):
        current, original = self.transaction(lambda root, path, inventory: inventory['embedded_dependencies'].pop())
        self.assertEqual(original, current)

    def test_new_missing_snapshot_cannot_publish(self):
        def missing(root, path, inventory):
            inventory['pages']['new'] = {'cache': '.cache/missing.txt', 'sha256': 'b' * 64}
        current, original = self.transaction(missing)
        self.assertEqual(original, current)

    def test_interrupted_refresh_keeps_published_inventory_and_snapshot(self):
        def interrupt(root, path, inventory):
            SnapshotStore(root).document(b'new unpublished evidence', 'https://example/new')
            raise RuntimeError('simulated interruption')
        current, original = self.transaction(interrupt)
        self.assertEqual(original, current)

    def test_concurrent_inventory_edit_not_overwritten(self):
        changed = b'{"external_edit":true}\n'
        current, original = self.transaction(lambda root, path, inventory: path.write_bytes(changed))
        self.assertEqual(changed, current)
        self.assertNotEqual(original, current)

    def test_successful_transaction_publishes_complete_inventory(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            root = Path(temporary)
            path = root / 'architecture/references/sources.json'
            atomic_json(path, inventory_fixture())
            result = refresh(root=root, inventory_path=path, updater=lambda value: value.update(review='complete'))
            self.assertTrue(result['passed'])
            self.assertEqual('complete', json.loads(path.read_text())['review'])


class PresentationRegression(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.raw = json.loads((successful_run(REFERENCE) / 'workspace.json').read_text(encoding='utf-8-sig'))
        cls.before = normalize_presentation(cls.raw)

    def test_style_layout_description_and_property_changes_detected(self):
        mutations = [lambda w: w['views']['configuration']['styles']['elements'][0].update(background='#FF00FF'),
                     lambda w: w['views']['systemLandscapeViews'][0]['automaticLayout'].update(nodeSeparation=999),
                     lambda w: w['views']['systemLandscapeViews'][0].update(description='changed'),
                     lambda w: w['model']['people'][0]['properties'].update(custom='changed')]
        for mutate in mutations:
            raw = deepcopy(self.raw)
            mutate(raw)
            self.assertTrue(presentation_difference(self.before, normalize_presentation(raw)))

    def test_set_order_and_inspection_totals_are_ignored(self):
        raw = deepcopy(self.raw)
        raw['views']['systemLandscapeViews'].reverse()
        for view in raw['views']['systemLandscapeViews']:
            view.get('elements', []).reverse()
            view.get('relationships', []).reverse()
        raw['properties']['structurizr.inspection.info'] = '999'
        self.assertEqual([], presentation_difference(self.before, normalize_presentation(raw)))

    def test_style_cascade_order_is_preserved(self):
        raw = deepcopy(self.raw)
        raw['views']['configuration']['styles']['elements'].reverse()
        self.assertTrue(presentation_difference(self.before, normalize_presentation(raw)))


@unittest.skipUnless(os.environ.get('C4_DOCKER_TESTS') == '1', 'Set C4_DOCKER_TESTS=1 for parser integration')
class PublicationIntegration(unittest.TestCase):
    def test_success_then_disconnected_failure_isolated_end_to_end(self):
        before = source_snapshot()
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary, ExitStack() as patches:
            architecture = Path(temporary) / 'architecture'
            architecture.mkdir()
            shared = architecture / 'model.dsl'
            shared.write_text('workspace {\n !identifiers hierarchical\n !impliedRelationships false\n properties {\n "structurizr.inspection.workspace.scope" "info"\n }\n model {\n }\n views {\n }\n configuration {\n scope none\n }\n}\n')
            entry = architecture / 'initiatives/test/workspace.dsl'
            entry.parent.mkdir(parents=True)
            body = '''workspace extends ../../model.dsl {
    model {
        a = softwareSystem "A" "Sends example data" {
            properties {
                "architecture.id" "a"
                "evidence" "Proposed architecture"
            }
        }
        b = softwareSystem "B" "Receives example data" {
            properties {
                "architecture.id" "b"
                "evidence" "Proposed architecture"
            }
        }
        a -> b "Sends example data" "HTTPS" {
            properties {
                "evidence" "Proposed architecture"
                "architecture.sources" "[\\"Local design\\"]"
            }
        }
    }
    views {
        systemContext a "test-context" {
            title "System Context - Test"
            include a b
            autoLayout lr
        }
    }
}
'''
            entry.write_text(body)
            reference = architecture / 'workspace.dsl'
            for module in ('workspace_dependencies', 'validate_workspaces'):
                patches.enter_context(patch(module + '.SHARED', shared))
                patches.enter_context(patch(module + '.REFERENCE', reference))
            patches.enter_context(patch('workspace_dependencies.ARCHITECTURE', architecture))
            directory = Path(temporary) / 'outputs'
            patches.enter_context(patch('validate_workspaces.output_directory', return_value=directory))
            success = validate_workspaces([entry])[0]
            self.assertTrue(success['passed'], success['failure'])
            first = resolve_run(directory)[0]
            old = (first / 'workspace.json').read_bytes()
            entry.write_text(body.replace('include a b', 'include a b\n            exclude *->*'))
            failure = validate_workspaces([entry])[0]
            self.assertFalse(failure['passed'])
            second = resolve_run(directory, False)[0]
            self.assertEqual(first, resolve_run(directory)[0])
            self.assertEqual(old, (first / 'workspace.json').read_bytes())
            self.assertFalse((second / 'reports/inspect.txt').exists())
            self.assertIn('connected diagram', failure['failure'])
        self.assertEqual(before, source_snapshot())


if __name__ == '__main__':
    unittest.main()
