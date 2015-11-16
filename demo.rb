
# click 在线融资
kr.div(:class, "navbar-collapse collapse").link(:href, "product/finance").send_keys :enter
#人物
kr.div(:class, "navbar-collapse collapse").link(:href, "/person").send_keys :enter
#项目
kr.div(:class, "navbar-collapse collapse").link(:href, "/product").send_keys :enter


module KR
	module Project
		extend self
        attr_accessor :context
        def self.goto_project_icon
        end
        def self.goto_project_icon_page
			KR.browser.link(:href, "flow").click	
		end		
		def self.send_newline
            KR.browser.send_keys("\n")
        end
        def self.open_dialog(file_path)
            autoit = WIN32OLE.new('AutoItX3.Control')    #init autoit            
            autoit.WinWaitActive("打开", "", 9)    #acitve choose file window
            sleep 1
            autoit.ControlSetText("打开", "", "Edit1", file_path)    #input file path
            sleep 1
            autoit.ControlClick("打开", "", "Button2")    #click open button
            sleep 1                
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
		def goto_create_person_page
			KR.browser.goto "http://innerwww.36kr.net:30090/person/investor"
		end
		class Penson
			def creat_investor(args)
				name  = args[:name]
				img_file = args[:img_file]
				phone = args[:phone]
				keywords = args[:keywords]
				min_fund = args[:min_fund]
				max_fund = args[:max_fund]
				r = ""
				Project.goto_create_person_page
				Project.text_field(:name, "username").set("lisna")
				Project.text_field(:name, "phone").set("15210865177")
				Project.open_dialog(img_file)
				Project.text_field(:id, "inputKeywords").set("inter")
				Project.text_field(:name, "min_fund").set("100")
				Project.text_field(:name, "max_fund").set("1000")
				Project.button(:type, "submit").click
				sleep 5
				Project.button(:type, "submit").click

				#img_file=>PATH + "\\upload\\img\\img1.jpg"
			end
		end
		class Project
			def create_project(args)

		end

	end
end