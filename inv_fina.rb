#encoding: utf-8
module KR
	module Project
		extend self
        attr_accessor :context

        def self.goto_page
			KR.browser.link(:href, "flow").click	
		end		
		def self.send_newline
            KR.browser.send_keys("\n")
        end
        def self.goto_project_icon_page
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
	            	Project.textarea(:name, "users_scale_activity").append(com)
	            	Project.send_newline
            	}
            	next_step.each{|plan|
                	Project.textarea(:name, "next_step").append(plan)
                	Project.send_newline
                }
                Project.textarea(:name, "market_structure").append(market_structure)
                               
			end
		end
	end
end