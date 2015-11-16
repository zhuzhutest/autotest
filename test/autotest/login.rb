require "watir-webdriver"


module KR
	
	module Login
		class Login	
			def modalbox_login
				KR.browser.div(:class, "modal-body").div(:class, "col-md-6 kr-login")
			end
			def modalbox_register
				KR.browser.div(:class, "modal-body").div(:class, "col-md-6")
			end
			def login(site, username, password)
				r = ""
				KR.browser.goto(site)
				KR.browser.link(:href, "signin").click
				KR.browser.modalbox_login.text_field(:name, "email").set(username)
				sleep 1
				KR.browser.modalbox_login.text_field(:name, "pwd").set(password)
				KR.browser.modalbox_login.button(:type, "submit").click
				sleep 2
				if KR.browser.div(:class, "navbar-collapse collapse").link(:class, "project-icon text").exists?
					r+ = "succeed to login"
				else
					r+ = "failed to login"
				end				
			end	
			def register(args)
				lastname  = args[:lastname]
				firstname = args[:firstname]
				nickname  = args[:nickname]
				email     = args[:email]
				password  = args[:password]
				r = ""

				KR.browser.modalbox_register.text_field(:name, "lastname").set(lastname)
				KR.browser.modalbox_register.text_field(:name, "firstname").set(firstname)
				KR.browser.modalbox_register.text_field(:name, "nickname").set(nickname)
				KR.browser.modalbox_register.text_field(:name, "email").set(email)
				KR.browser.modalbox_register.text_field(:name, "password").set(password)
				KR.browser.modalbox_register.button(:type, "submit").click
				# if check_register
				# 	puts succ
				# else
				# 	puts  failed
				# end
			end
		end	
	end
	
end	

