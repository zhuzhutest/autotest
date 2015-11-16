#require 'watir-webdriver'
require 'watir'

$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))
require 'login'
require 'project'

module KR
	
	def self.init_browser(browser)
		@ie = case browser
					when "ie"
						Watir::Browser.new:ie
					when "ff"
						Watir::Browser.new:ff
					when "chrome"
						Watir::Browser.new:chrome, :switches => %w[--start-maximized]
					when "safari"
						Watir::Browser.new:safari
					else
						puts "browser doesn't init!"
					end
	end
				
	def self.browser
		@ie 
	end

    def self.screen(filename)
        @ie.screenshot.save filename
        @ie.screenshot.png
        @ie.screenshot.base64
    end
end