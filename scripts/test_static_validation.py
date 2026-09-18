"""Fault-injection tests for validation gates using the actual parsed model."""
from copy import deepcopy
from pathlib import Path
import json
import os
import tempfile
import unittest
from check_inspect import assess
from audit_static_workspace import audit, ROOT
from audit_security_catalog import audit_security_catalog
from dsl_relationships import relationship_selectors

class InspectionPolicy(unittest.TestCase):
    def test_scope_findings_have_no_fixed_count(self):
        for count in (1,3,7):
            text='\n'.join('INFO | workspace.scope | intentional ecosystem scope' for _ in range(count))
            self.assertTrue(assess(text,count)['passed'])
    def test_other_information_is_not_silently_accepted(self):
        self.assertFalse(assess('INFO | model.component.description | absent',1)['passed'])
    def test_warning_and_fatal_exit_fail(self):
        self.assertFalse(assess('WARNING | model.element.noview | absent',1)['passed'])
        self.assertFalse(assess('Unable to parse workspace',1)['passed'])
        self.assertFalse(assess('INFO | workspace.scope | expected',0)['passed'])

class RelationshipSelection(unittest.TestCase):
    def setUp(self):
        self.browser={'id':'browser','source':'apps.client','destination':'entraId.authentication',
                      'description':'Submits browser authorization request'}
        self.workload={'id':'workload','source':'apps.client','destination':'entraId.authentication',
                       'description':'Authenticates workload identity and requests HSM-audience access token'}

    def test_full_pair_needs_no_alias(self):
        self.assertEqual(['apps.client->entraId.authentication'],
                         relationship_selectors([self.browser,self.workload],['browser','workload']))

    def test_workload_subset_does_not_include_browser_arrow(self):
        self.assertEqual(['hsmWorkloadTokenRequest'],
                         relationship_selectors([self.browser,self.workload],['workload']))

    def test_unrecognized_subset_fails_instead_of_broadening(self):
        with self.assertRaisesRegex(ValueError,'descriptive relationship name'):
            relationship_selectors([self.browser,self.workload],['browser'])

class ParsedModelFaults(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if os.environ.get('C4_PARSED_WORKSPACE'):
            path=Path(os.environ['C4_PARSED_WORKSPACE'])
        else:
            run=json.loads((ROOT/'reports/static/run.json').read_text())
            path=ROOT/run['parsed_workspace']
        cls.original=json.loads(path.read_text())
    def check_fault(self,modify,expected):
        broken=deepcopy(self.original);modify(broken)
        with tempfile.TemporaryDirectory(prefix='c4-audit-test-') as directory:
            path=Path(directory)/'workspace.json';path.write_text(json.dumps(broken),encoding='utf-8')
            result=audit(path,write_report=False,verbose=False)
        self.assertFalse(result['passed'])
        self.assertTrue(any(expected in error for error in result['errors']),result['errors'])
    def test_missing_view_dataflows_fail(self):
        self.check_fault(lambda w:w['views']['componentViews'][0].update(relationships=[]),'visible static dataflow exists')
    def test_wrong_relationship_endpoints_fail(self):
        def change(w):
            systems=w['model']['softwareSystems']
            owner=next(s for s in systems if s.get('relationships'))
            owner['relationships'][0]['destinationId']=systems[-1]['id']
        self.check_fault(change,'Parsed relationships exactly match authored endpoints')
    def test_deployment_content_is_rejected(self):
        self.check_fault(lambda w:w['model'].update(deploymentNodes=[{'id':'unexpected'}]),'Static input contains no deployment nodes')

class SecurityCatalogFaults(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.catalog=json.loads((ROOT/'model-catalog.json').read_text(encoding='utf-8'))
        cls.sources=json.loads((ROOT/'sources.json').read_text(encoding='utf-8'))

    def check_fault(self, modify, expected):
        catalog=deepcopy(self.catalog)
        sources=deepcopy(self.sources)
        modify(catalog,sources)
        failures=[c['check'] for c in audit_security_catalog(catalog,sources) if not c['passed']]
        self.assertTrue(any(expected in f for f in failures),failures)

    def test_unmodified_security_reference_passes(self):
        self.assertEqual([], [c['check'] for c in audit_security_catalog(self.catalog,self.sources) if not c['passed']])

    def test_broker_example_rejects_direct_login_leak(self):
        def change(c,s):
            v=next(v for v in c['views'] if v['key']=='100-security-example-broker-entra')
            r=next(r for r in c['relationships'] if r['source']=='apps.client' and r['destination']=='entraId.authentication')
            v['relationships'].append(r['id'])
        self.check_fault(change,'broker-entra excludes competing direct-login paths')

    def test_private_key_return_is_rejected(self):
        def change(c,s):
            r=next(r for r in c['relationships'] if r['source']=='managedHsm.service' and r['destination']=='apps.hsmSigner')
            r['description']='Returns private key material to the signing proxy'
        self.check_fault(change,'HSM output descriptions contain no private-key export claim')

    def test_adapter_must_be_labeled_as_proposed(self):
        def change(c,s):
            r=next(r for r in c['relationships'] if r['source']=='firefly.evm' and r['destination']=='apps.hsmSigner')
            r['tags']=r['tags'].replace(',ReferenceIntegration','')
        self.check_fault(change,'all custom signing adapter relationships are marked proposed')

    def test_management_plane_cannot_invoke_key_operations(self):
        def change(c,s):
            r=next(r for r in c['relationships'] if r['source']=='azureManagement' and r['destination']=='managedHsm.service')
            r['destination']='managedHsm.service.crypto'
        self.check_fault(change,'resource management does not bypass HSM local key authorization')

    def test_missing_evidence_fingerprint_is_rejected(self):
        self.check_fault(lambda c,s:s['pages']['security-pam'].pop('sha256'), 'has fingerprint, retrieval time and capture method')

if __name__=='__main__':unittest.main()
