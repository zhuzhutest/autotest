
# # click 在线融资
# kr.div(:class, "navbar-collapse collapse").link(:href, "product/finance").send_keys :enter
# #人物
# kr.div(:class, "navbar-collapse collapse").link(:href, "/person").send_keys :enter
# #项目
# kr.div(:class, "navbar-collapse collapse").link(:href, "/product").send_keys :enter
require 'applescript'
require 'watir'


module KR
	module Project
        def self.goto_page
			KR.browser.link(:href, "flow").click	
		end		
		def self.send_newline
            KR.browser.send_keys("\n")
        end
        
        
		class Financing
			def select_project
				Project.image(:index, 2).click
				Project.span(:xpath, "//div[@class='agreement-checkbox']/label/span").click
				Project.link(:class, "btn-fill").click
			end
			def input_Respondents_table(args)
				users_scale_activity = args[:users_scale_activity]
				competitor           = args[:competitor]
				next_step            = args[:plan]
				market_structure     = args[:structure]
				r = ""
				users_scale_activity.each { |usa|
	                Project.textarea(:name, "users_scale_activity").append(usa)
	                Project.send_newline
                }
                competitor.each{|com|
	            	Project.textarea(:id, "competitors").append(com)
	            	Project.send_newline
            	}
            	next_step.each{|plan|
                	Project.textarea(:name, "next_step").append(plan)
                	Project.send_newline
                }
                Project.textarea(:name, "market_structure").append(market_structure)
                Project.div(:class, "form-footer").button(:type, "submit").click
                               
			end
		end
		class Project
			def self.creat_pro_search(project_name, staus)
				if !project_name
	        	KR.browser.link(:xpath, "//*[@id='product-menu']").click
	        	sleep 1
	        	KR.browser.div(:class, "kr-product-link open").link(:class, "btn kr-btn btn-bigger").click
	        	sleep 2
	        	KR.browser.div(:class, "modal-box").div(:class, "kr-create-search").text_field(:name, "name").set(project_name)
	        	sleep 2
				KR.browser.form(:class, "form-horizontal").button(:id, "kr-search-product").click
				sleep 2
				KR.browser.div(:class, "kr-modal-con kr-modal-begin").link(:class, "btn kr-btn btn-bigger").click
	        end
	        def create_pro_page
	        	KR.browser.div(:class, "container product-guide")	        	
	        end
	        def self.upload_img
	        	`/Users/kr/autotest/autotest_master/test.sh`
        	end
			def creat_project(args)
				project_name = args[:project_name]
				position     = args[:position]
				needtail     = args[:needtail]
				abstract     = args[:abstract]
				keywords     = args[:keywords]
				companyname  = args[:companyname]
				email        = args[:email]
				r = ""

				Project.creat_pro_search(project_name)
				KR.browser.text_field(:name, "position").set(position)
				sleep 2
				KR.browser.text_field(:name, "needtail").set(needtail)
				sleep 2
				KR.browser.textarea(:name, "abstract").append(abstract)
				sleep 2
				KR.browser.text_field(:xpath, "//*[@id='inputKeywords']").set(keywords)
				sleep 3
				KR.browser.span(:xpath, "//*[@class='col-md-5']/div/label[1]/span").click
				sleep 3
				KR.browser.div(:id, "inputShapeAddtionalBox").text_field(:name, "web").set("www.#{project_name}.com")
				sleep 5
				KR.browser.span(:xpath, "//*[@id='inputCategory']/label[1]/span").fire_event :click
				sleep 5
				KR.browser.span(:class, "add-on").click
				sleep 5
				KR.browser.td(:xpath, "//*[@class=' table-condensed']/tbody/tr[5]/td[6]").click
				sleep 5
				KR.browser.div(:id, "logoUpdoad").image(:src, "http://img.36tr.com/img/file/fileupload.png").click
				sleep 5
				##
				sleep 10
				KR.browser.div(:id, "pictureUpload").image(:src, "http://img.36tr.com/img/file/fileupload.png").click
				sleep 5
				##`/Users/kr/autotest/autotest_master/test.sh`
				sleep 10
				KR.browser.text_field(:xpath, "//*[@id='inputCompanyName']").set(companyname)
				sleep 5
				KR.browser.span(:xpath, "//*[@id='container']/div[4]/form/fieldset/div[19]/div/div/div/div[1]/span").click
				sleep 1
				KR.browser.p(:xpath, "//*[@id='container']/div[4]/form/fieldset/div[19]/div/div/div/div[2]/p[2]").click
				sleep 2
				KR.browser.text_field(:xpath, "//*[@id='inputEmail']").text_field(:xpath, "//*[@id='inputEmail']").set(email)
				sleep 2
				KR.browser.div(:class, "form-actions text-center").button(:class, "btn kr-btn btn-large").click
				sleep 10
				KR.browser.button(:class, "btn kr-btn btn-large").click
				r = "succeed to login"
			end
			def update_project(args)

				b.text_field(:name, "needtail").set("haip")
				b.textarea(:name, "abstract").append("tst")
				b.text_field(:id, "inputKeywords").set("tet")
				
			end
			def 
				
			end

		end

	end
end