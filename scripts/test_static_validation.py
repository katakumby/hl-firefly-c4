"""Fault-injection tests for validation gates using the actual parsed model."""
from copy import deepcopy
from pathlib import Path
import json
import os
import tempfile
import unittest
from check_inspect import assess
from audit_static_workspace import audit, ROOT

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

if __name__=='__main__':unittest.main()
