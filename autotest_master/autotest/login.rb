#require 'watir-webdriver'
require 'watir'


module KR
	
	module Login
		class Login	
			def login(site, username, password)
				KR.browser.goto(site)
				KR.browser.link(:xpath, "//*[@id='nav-toolbar']/li[1]/a").click
				KR.browser.table(:class, "ui-dialog-grid").text_field(:name, "email").set(username)
				sleep 1
				KR.browser.table(:class, "ui-dialog-grid").text_field(:name, "password").set(password)
				KR.browser.table(:class, "ui-dialog-grid").button(:type, "submit").click
				sleep 2
				r = "succeed"
				# if KR.browser.div(:class, "navbar-collapse collapse").link(:class, "project-icon text").exists?
				# r += "succeed to login"
				# else
				# r += "failed to login"
				# end
			end
			def back_login(site, username, password)
			end
			def register(args)
				nickname  = args[:nickname]
				email     = args[:email]
				password  = args[:password]
				phone     = args[:phone]
				r = ""

				KR.browser.goto(site)
				KR.browser.link(:href, "signup").click
				KR.browser.text_field(:name, "email").set(email)
				KR.browser.text_field(:name, "nickname").set(nickname)
				KR.browser.text_field(:name, "password").set(password)
				KR.browser.text_field(:name, "phone").set(phone)
				KR.browser.text_field(:name, "code").set("123456")
				KR.browser.button(:class, "btn btn-default submit").click
				# if check_register
				# 	puts succ
				# else
				# 	puts  failed
				# end
			end
		end	
	end
	
end	

