require 'watir'

module KR
	module Back
		class Back_system
			def self.login_back
				r = ""
				KR.browser.goto "http://testadm.36kr.net/"
				KR.browser.text_field(:name, "email").set("shijianbo")
				KR.browser.text_field(:name, "password").set("HUGV5TQI")
				KR.browser.button(:class, "btn green pull-right").click
				if KR.browser.text.include?("shijianbo")
					r = "succeed to login back system"
				else
					r = "failed to login back system"
				end
			end

			def examine_project
				r = ""
				Back.login_back
				KR.browser.span(:xpath, "//*[@id='18']/div[2]/div[1]/ul/li[4]/a/span[1]").click
				sleep 2
				KR.browser.link(:href, "product/apply").click
				sleep 2
				KR.browser.a(:xpath, "//*[@id='18']/div[2]/div[2]/div/div[2]/div[2]/div[2]/ul/li[2]/div/div[2]/div[1]/div/a[2]").click
				sleep 2
				`/Users/kr/autotest/autotest_master/send_enter.sh`
				sleep 2
				r = "success to review project"

			end
			def search_project(args)
				KR.browser.text_field(:name, "q").set(project_name)
 				
			end