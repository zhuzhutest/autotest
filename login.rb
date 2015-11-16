require "watir-webdriver"


module KR
	
	module LOGIN
		extend self
        attr_accessor :context
        	def modalbox_login
				KR.browser.div(:class, "modal-body").div(:class, "col-md-6 kr-login")
			end
			def modalbox_register
				KR.browser.div(:class, "modal-body").div(:class, "col-md-6")
			end
		class Login	
			
			def login(site, username, password)
				r = ""
				KR.browser.goto(site)

				KR.browser.modalbox_login.link(:href, "signin").click
				KR.browser.table(:class, "ui-dialog-grid").text_field(:name, "email").set(username)
				sleep 1
				KR.browser.table(:class, "ui-dialog-grid").text_field(:name, "password").set(password)
				KR.browser.table(:class, "ui-dialog-grid").button(:type, "submit").click
				sleep 2
				# if KR.browser.div(:class, "navbar-collapse collapse").link(:class, "project-icon text").exists?
				# 	r += "succeed to login"
				# else
				# 	r += "failed to login"
				# end				
			end
			def back_login(site, username, password)
				344898
						
			end	
			def register(args)
				nickname  = args[:nickname]
				email     = args[:email]
				password  = args[:password]
				r = ""

				KR.browser.goto(site)
				KR.browser.link(:href, "signup").click
				KR.browser.text_field(:name, "email").set(email)
				KR.browser.text_field(:name, "nickname").set(nickname)
				KR.browser.text_field(:name, "password").set(password)
				KR.browser.text_field(:name, "phone").set(phone)
				KR.browser.text_field(:name, "code").set("")
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

