#-*- coding: UTF-8 -*- 
import requests
import unittest
import json

CHEN = {"Cookie":"kr_stat_uuid=MbAt423866721; kr_plus_id=11788; kr_plus_token=e1d62c73d8be4cbb85f7ab052aa134f55ec51c83; _gat=1; _ga=GA1.2.635728409.1432003315; Hm_lvt_e8ec47088ed7458ec32cde3617b23ee3=1431939970,1431997639,1432007152; Hm_lpvt_e8ec47088ed7458ec32cde3617b23ee3=1432007160; krchoasss=eyJpdiI6Iks1TE9RU055TGRKRTByWUhkM2RSdVE9PSIsInZhbHVlIjoiVGVrQ0hVOXlleTdKaHpiM0VLUFwvdWw4Y0ducnN4S2trVTFNcjN1bTUxaXowbDdqMXBBY0NWbFpoYmZzRjNQUTBXMWFIc2d1bDZ3aTRPTnlIUW5yaG9nPT0iLCJtYWMiOiI1YTMxNzU3Y2IyNzg5MzZlMzhkNTRjNTY1M2EyOTc4YTYxNDYwNWQxZWFmYzcxN2RhNjY5ZGVhNmI1ZjM3NmFkIn0%3D; _krypton_session=c867fa19ef1c5e584953425a90dc6e37; krid_user_version=6; krid_user_id=184997; _auth_session=a09db924a0ce9b543b0d9c1df3dd65ad"}
JING = {"Cookie":'''_gat=1; kr_plus_id=11780; kr_plus_token=8406f8c1ecec8e376d0486b1aa1af68b61cfee3c; kr_stat_uuid=SQnTN23866788; _ga=GA1.2.1564188536.1432007269; Hm_lvt_e8ec47088ed7458ec32cde3617b23ee3=1431939970,1431997639,1432007152; Hm_lpvt_e8ec47088ed7458ec32cde3617b23ee3=1432007317; _krypton_session=3915de7276516bc4acc58d420f0a8289; krchoasss=eyJpdiI6Imt6djRYYU5kYm9QNG9PMDdzUEVLMlE9PSIsInZhbHVlIjoiWk10UW9aUkpvcjZVUTZiY3ZcL2hyN3ZDQ3FuTG9JQXNTUG03V2FLaFpuZGlMZ1hhUDNSd25jK1FcL3hpd2tmQzNiVmowajh3ajJwV3BcL1NjNlhvV1luSXc9PSIsIm1hYyI6ImM5ZjhiZWU4MzM2MDQ1NjlkMWZlMDM2MDljYjBjNjQwMjgwZTQ2MDRhOTNmYzA4YmE2MWIxMDkxZjQwNTg1NzcifQ%3D%3D; krid_user_version=2; krid_user_id=182864; _auth_session=d258263a83aa08753973f949497e93a1'''}
HIGH_INVESTOR = {"Content-type":"application/x-www-form-urlencoded",'Cookie':'kr_stat_uuid=fxaPr23881085; kr_plus_id=69336; kr_plus_token=067a203b3e4f80a8dd81c2f9384052b096248fd5; _gat=1; _ga=GA1.2.370057440.1432865120; krid_user_version=6; krid_user_id=123897; _auth_session=c891f612700e53c68f9904fbab5dec71; _krypton_session=2922adfe93d42a942166ed832e1deeed'}

headers = HIGH_INVESTOR
#data = {}
#api = "api/company/count-all"
# class TestCompany(unittest.TestCase):
#     def send_get(self):
#         r = requests.get("https://rongtest.36kr.com/%s" % api)
#         a = r.json()
#         return a['code']

#     def test_company_list(self):
#         api = "/api/company?fincestatus=2&page=1&type="
#         self.assertEqual(self.send(api), 0)
