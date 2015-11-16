require File.dirname(__FILE__)+'/../run_case.rb'
require 'watir'

module KR
	module BackSystme
		extend self
        attr_accessor :context
        def self.goto_page
			KR.browser.goto "inneradm.36kr.net:30021"
		end
		def self.send_newline
            KR.browser.send_keys("\n")
        end
        def self.search_elem(elem_name)
            KR.browser.div(:class, "input-box").text_field(:name, "q").set(elem_name)
            KR.browser.button(:class, "submit").click
            KR.browser.button(:class, "btn dropdown-toggle").click
            KR.browser.link(:xpath, "//*[@class='btn-group pull-right open']/ul/li[1]/a").click
        end
        class LOGIN
        def login
            r = ""
        	KR.browser.text_field(:name, "email").set("shijianbo")
            KR.browser.text_field(:name， "password").set("HUGV5TQI")
            KR.browser.button(:type, "submit").click
            sleep 2
            if KR.browser.div(:class, "header-inner").exists?
                r += "succeed to login BackSystme"
            else
                r += "failed to login BackSystme"
            end
            return r
        end

        end
        def method_name
            
        end
	end
end