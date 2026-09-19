"""Fault-injection and parser integration tests for modular architecture tooling.

Run validation first. Set C4_DOCKER_TESTS=1 to include actual pinned-parser tests.
"""
from copy import deepcopy
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from architecture_validation import audit, check_local_links
from check_inspect import assess
from validate_workspaces import dependencies, docker_command, source_snapshot
from workspace_catalog import normalize, semantic_difference, write_catalog
from workspace_paths import ROOT, REFERENCE, BUILD, SOURCES, discover_workspaces, output_directory, workspace_path
from artifact_store import successful_run


def focused_context(reference):
    return {'shared_ids': {e['id'] for e in normalize(reference)['elements']},
            'inherited_views': set(), 'prefix': 'ignition-', 'placeholder': True}


class InspectionPolicy(unittest.TestCase):
    def test_scope_findings_have_no_fixed_count(self):
        for count in (1,3,7):
            text='\n'.join('INFO | workspace.scope | intentional scope' for _ in range(count))
            self.assertTrue(assess(text,count)['passed'])

    def test_unrelated_information_warning_and_fatal_exit_fail(self):
        for text in ('INFO | model.component.description | absent',
                     'WARNING | model.element.noview | absent', 'Unable to parse workspace'):
            self.assertFalse(assess(text,1)['passed'])

    def test_focused_policy_is_explicit(self):
        text='INFO | model.element.noview | inherited reference'
        self.assertFalse(assess(text,1)['passed'])
        self.assertTrue(assess(text,1,{'workspace.scope','model.element.noview'})['passed'])
        self.assertFalse(assess(text.replace('INFO','ERROR'),1,{'model.element.noview'})['passed'])


class SemanticFaults(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.reference=json.loads((successful_run(REFERENCE)/'workspace.json').read_text(encoding='utf-8-sig'))
        cls.ignition=json.loads((successful_run(ROOT/'architecture/initiatives/ignition/workspace.dsl')/'workspace.json').read_text(encoding='utf-8-sig'))
        cls.sources=json.loads(SOURCES.read_text(encoding='utf-8'))

    def check_fault(self, modify, expected, reference=True):
        raw=deepcopy(self.reference if reference else self.ignition)
        catalog=normalize(raw); modify(raw,catalog)
        result=audit(raw,catalog,self.sources,reference,focused_context(self.reference))
        self.assertFalse(result['passed'])
        self.assertTrue(any(expected in error for error in result['errors']),result['errors'])

    def test_current_workspaces_pass(self):
        for raw,reference in ((self.reference,True),(self.ignition,False)):
            result=audit(raw,normalize(raw),self.sources,reference,focused_context(self.reference))
            self.assertTrue(result['passed'],result['errors'])

    def test_missing_dataflows_fail(self):
        self.check_fault(lambda w,c:c['views'][0].update(relationships=[]),'visible static dataflow')

    def test_unrelated_disconnected_element_fails(self):
        self.check_fault(lambda w,c:c['views'][0]['elements'].append('business'),'connected diagram',False)

    def test_unrelated_singleton_is_not_exempt(self):
        self.check_fault(lambda w,c:c['views'][0].update(key='ignition-other',scope='firefly',elements=['firefly']),
                         'visible static dataflow',False)

    def test_duplicate_view_keys_fail(self):
        self.check_fault(lambda w,c:c['views'].append(deepcopy(c['views'][0])),'Unique view keys')

    def test_missing_evidence_fails(self):
        self.check_fault(lambda w,c:c['relationships'][0].update(evidence=[]),'labeled mechanism and evidence')

    def test_broad_inspection_suppression_fails(self):
        self.check_fault(lambda w,c:w.setdefault('properties',{}).update({'structurizr.inspection.*':'ignore'}),
                         'narrowly scoped inspection policy',False)

    def test_deployment_content_fails(self):
        self.check_fault(lambda w,c:w['model'].update(deploymentNodes=[{'id':'unexpected'}]),'No deployment content')

    def test_foreign_components_fail(self):
        def change(w,c):
            view=next(v for v in c['views'] if v['kind']=='component')
            view['elements'].append('besu.node.qbft')
        self.check_fault(change,'components belong to scope')

    def test_duplicate_architecture_id_cannot_normalize(self):
        raw=deepcopy(self.reference)
        raw['model']['people'][1]['properties']['architecture.id']=raw['model']['people'][0]['properties']['architecture.id']
        with self.assertRaisesRegex(ValueError,'Duplicate architecture.id'): normalize(raw)

    def test_invalid_endpoint_cannot_normalize(self):
        raw=deepcopy(self.reference)
        system=next(s for s in raw['model']['softwareSystems'] if s.get('relationships'))
        system['relationships'][0]['destinationId']='missing'
        with self.assertRaises(KeyError): normalize(raw)

    def test_exact_view_selection_comparison_detects_loss(self):
        before=normalize(self.reference); after=deepcopy(before)
        after['views'][0]['relationships'].pop()
        self.assertTrue(semantic_difference(before,after))

    def test_normalization_is_order_independent_for_comparison(self):
        before=normalize(self.reference); after=deepcopy(before)
        after['elements'].reverse(); after['views'][0]['elements'].reverse()
        self.assertEqual([],semantic_difference(before,after))


class LocalWorkflow(unittest.TestCase):
    def test_discovery_and_output_separation(self):
        paths=discover_workspaces()
        self.assertEqual(ROOT/'architecture/workspace.dsl', REFERENCE)
        self.assertEqual(REFERENCE, workspace_path())
        self.assertIn(REFERENCE,paths)
        self.assertIn(ROOT/'architecture/initiatives/ignition/workspace.dsl',paths)
        self.assertEqual(len(paths),len({output_directory(p) for p in paths}))
        self.assertEqual(ROOT/'build/architecture', BUILD)
        self.assertEqual(BUILD/'reference', output_directory(REFERENCE))
        self.assertEqual(BUILD/'initiatives/ignition/workspace',
                         output_directory(ROOT/'architecture/initiatives/ignition/workspace.dsl'))
        self.assertTrue(all(output_directory(path).is_relative_to(BUILD) for path in paths))

    def test_outside_workspace_rejected(self):
        with self.assertRaises(ValueError): workspace_path(ROOT.parent/'outside.dsl')

    def test_document_links_resolve(self):
        self.assertEqual([],check_local_links())

    def test_all_dependency_graphs_resolve(self):
        for path in discover_workspaces(): self.assertIn(path,dependencies(path))

    def test_missing_include_and_cycle_fail(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'build/architecture',prefix='test-dependencies-') as directory:
            path=Path(directory)/'workspace.dsl'
            path.write_text('workspace {\n model {\n !include missing.dsl\n }\n}\n')
            with self.assertRaisesRegex(ValueError,'Missing DSL'): dependencies(path)
            path.write_text('workspace extends workspace.dsl {\n}\n')
            with self.assertRaisesRegex(ValueError,'Cyclic DSL'): dependencies(path)

    def test_catalog_output_does_not_mutate_sources(self):
        before=source_snapshot()
        raw=json.loads((successful_run(REFERENCE)/'workspace.json').read_text(encoding='utf-8-sig'))
        with tempfile.TemporaryDirectory(dir=ROOT/'build/architecture',prefix='test-output-') as directory:
            write_catalog(raw,directory)
        self.assertEqual(before,source_snapshot())


@unittest.skipUnless(os.environ.get('C4_DOCKER_TESTS')=='1','Set C4_DOCKER_TESTS=1 to run pinned-parser tests')
class PinnedParser(unittest.TestCase):
    def run_fixture(self,text,export=False):
        with tempfile.TemporaryDirectory(dir=ROOT/'build/architecture',prefix='test-parser-') as directory:
            path=Path(directory)/'workspace.dsl'
            parent=Path(os.path.relpath(ROOT/'architecture/initiatives/ignition/workspace.dsl',directory)).as_posix()
            path.write_text(text.replace('EPIC_PARENT',parent),encoding='utf-8')
            command=['export','-format','json','-output',path.parent.relative_to(ROOT).as_posix()] if export else ['validate']
            result=subprocess.run(docker_command()+command+['-workspace',path.relative_to(ROOT).as_posix()],
                                  cwd=ROOT,capture_output=True,text=True,encoding='utf-8',timeout=60)
            raw=json.loads((path.parent/'workspace.json').read_text(encoding='utf-8-sig')) if export and result.returncode==0 else None
            return result,raw

    def test_missing_include_rejected(self):
        result,_=self.run_fixture('workspace {\n model {\n !include missing.dsl\n }\n}\n')
        self.assertNotEqual(0,result.returncode)

    def test_duplicate_dsl_identifiers_rejected(self):
        result,_=self.run_fixture('workspace {\n model {\n a = softwareSystem "A"\n a = softwareSystem "B"\n }\n}\n')
        self.assertNotEqual(0,result.returncode)

    def test_invalid_relationship_rejected(self):
        result,_=self.run_fixture('workspace {\n model {\n a = softwareSystem "A"\n a -> missing "Calls"\n }\n}\n')
        self.assertNotEqual(0,result.returncode)

    def test_duplicate_view_key_rejected(self):
        result,_=self.run_fixture('workspace extends EPIC_PARENT {\n views {\n systemContext dapp_platform "ignition-dapp-platform-context" {\n include dapp_platform\n }\n }\n}\n')
        self.assertNotEqual(0,result.returncode)

    def test_variant_inherits_current_epic(self):
        before=source_snapshot()
        result,raw=self.run_fixture('workspace extends EPIC_PARENT {\n name "Temporary target variant"\n}\n',True)
        self.assertEqual(0,result.returncode,result.stdout+result.stderr)
        parent=json.loads((successful_run(ROOT/'architecture/initiatives/ignition/workspace.dsl')/'workspace.json').read_text(encoding='utf-8-sig'))
        self.assertEqual([],semantic_difference(normalize(parent),normalize(raw)))
        self.assertEqual(before,source_snapshot())


if __name__=='__main__': unittest.main()
