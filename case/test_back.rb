require File.dirname(__FILE__)+ '/../kr'
require File.dirname(__FILE__)+ '/../back_system'

PATH=File.dirname(__FILE__).gsub("/", "\\")

class TEST_BACK
	CBACK_LOGIN = KR::BackSystme::LOGIN.new

	def test_bakc_login
		r = []
		r.push(CBACK_LOGIN.login)
	end
end