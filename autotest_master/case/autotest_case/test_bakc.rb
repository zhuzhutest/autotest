require File.dirname(__FILE__)+ '/../back'

class TEST_BACK
		CBACK_SYSTEM   = KR::Back::Back_system.new

		def test_examine_project
			r = []
			r.push(CBACK_SYSTEM.examine_project(:))
			
		end
		def test_creat_project
    	r = []
	 	r.push(CPRO_PROJECT.creat_project(:project_name=>"teesetetesttesttest", :position=>"CEO", :needtail=>"test", :abstract=>"test", :keywords=>"test", :companyname=>"hahaw网路技术有限公司", :email=>"344264366@qq.com"))
	 	r.push(CPRO_PROJECT.creat_project(:project_name=>"测试专用项目", :position=>"CEO", :needtail=>"自动化测试", :abstract=>"自动化测试", :keywords=>"测试", :companyname=>"测试网路技术有限公司", :email=>"344264366@qq.com"))
		end
end
