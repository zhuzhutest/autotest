#-*- coding: UTF-8 -*-
#import http.client ,urllib
import urllib
import httplib
import unittest
import json
import requests

HOST = "rongtest4.36kr.com"
HIGH_INVESTOR = {"Content-type":"application/x-www-form-urlencoded",'Cookie':'kr_stat_uuid=fxaPr23881085; kr_plus_id=69336; kr_plus_token=067a203b3e4f80a8dd81c2f9384052b096248fd5; _gat=1; _ga=GA1.2.370057440.1432865120; krid_user_version=6; krid_user_id=123897; _auth_session=c891f612700e53c68f9904fbab5dec71; _krypton_session=2922adfe93d42a942166ed832e1deeed'}


class TestCompany(unittest.TestCase):

    def setUp(self):
        print ("start test")

    # def raises_(expected_exc, fun, *args, **kwargs):
    #     try:
    #         fun(*args, **kwargs)
    #     except Exception as exc:
    #         assert type(exc) == expected_exc
    #         return
    #     raise AssertionError("Exception %s not raised" % expected_exc.__name__)

    def send(self, methed, api, headers=None, data=None):
        if not headers:
            headers = {}
        if not data:
            data = ""
        else:
            data = urllib.urlencode(data)
            print (data)

        conn = httplib.HTTPConnection(HOST)
        conn.request(methed, api, data, headers)
        response = conn.getresponse()
        code = response.status
        data = response.read()
        result = json.loads(data)
        print result
        code = result['code']
        print (code)
        return code

    def get_send(self, api, headers=None, params=None):
        if not headers:
            headers = {}
        conn = requests.get(api,params=params, headers = headers)

    def test_company_list(self):
        #methed = "GET"
        api = "%s/api/company?fincestatus=2&page=1&type=" % HOST
        params = {'fincestatus':2}
        self.assertEqual(self.send(methed,api), 0)

    def test_count_all(self):
        methed = "GET"
        api = "/api/company/count-all"
        headers= HIGH_INVESTOR
        self.assertEqual(self.send(api, headers), 0)

    def test_count_common(self):
        methed = "GET"
        api = "/api/company/count-common"
        self.assertEqual(self.send(methed, api), 0)

    def test_get_company(self):
        methed = "GET"
        api = "/api/company/142910"
        headers= HIGH_INVESTOR
        self.assertEqual(self.send(methed, api, headers), 0)

    def test_check_company(self):
        methed = "GET"
        api    = "/api/suggest/company?wd=ceshiceshi"
        headers= HIGH_INVESTOR
        self.assertEqual(self.send(methed, api, headers), 0)

    def test_update_company(self):
        methed = "PUT"
        api    = "/api/company/142900"
        headers= HIGH_INVESTOR
        data = {"cid" : 142900,
                "website" : "http://www.baidu.com",
                "brief":'第一次修改', "industry":"AUTO",
                "operationStatus":"OPEN"}
        self.assertEqual(self.send(methed,api,headers,data),0)

    def test_set_managed(self):
        methed = "PUT"
        api    = "/api/company/142900"
        headers= HIGH_INVESTOR
        data = {"manager":"68717"}
        self.assertEqual(self.send(methed,api,headers,data),0)

    def test_create_company(self):
        methed = "POST"
        api    = "/api/company"
        headers= HIGH_INVESTOR
        data   = {"name":"测试接口test1", "brief":"测试接口demo","type":"FOUNDER","position":"CEO","startDate":"2013-05-01 12:00:00","endDate":""}
        self.assertEqual(self.send(methed,api,headers,data),0)

    def tearDown(sefl):
        print ("     \ntest_done")

def suite():
    suite = unittest.TestSuite()
   # suite.addTest(TestCompany("test_company_list"))
    suite.addTest(TestCompany("test_count_all"))
    return suite
# if __name__ == '__main__':
#     unittest.main()
if __name__ == '__main__':
    unittest.main(defaultTest = 'suite')

