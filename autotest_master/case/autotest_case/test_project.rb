#encoding: utf-8
require File.dirname(__FILE__)+ '/../kr'
#require File.dirname(__FILE__)+ '/../project'

class TEST_PROJECT
		CPRO_PROJECT   = KR::Project::Project.new
		CPRO_FINANCING = KR::Project::Financing.new
		LOW_NUM = 1
    	HIGH_NUM = 5

    def test_creat_project
    	r = []
	 	r.push(CPRO_PROJECT.creat_project(:project_name=>"teesetetesttesttest", :position=>"CEO", :needtail=>"test", :abstract=>"test", :keywords=>"test", :companyname=>"hahaw网路技术有限公司", :email=>"344264366@qq.com"))
	 	#r.push(CPRO_PROJECT.creat_project(:project_name=>"测试专用项目", :position=>"CEO", :needtail=>"自动化测试", :abstract=>"自动化测试", :keywords=>"测试", :companyname=>"测试网路技术有限公司", :email=>"344264366@qq.com"))
	end
	def test_financing
	end
end