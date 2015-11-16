require 'net/http'
require 'uri'
require 'json'

#require 'global'

#LOCALHOST = 'testwww.36kr.net/'
LOCALHOST = 'http://krplus.test.36tr.com/'


	module Kr
		class Company
			def create_company
				api = "company"
				uri = URI.parse("#{LOCALHOST}" + api)
			    params = {"is_financing" => 0,"phase"=>1,"industry"=>11,"city"=>1101,"page"=>1,"page_size"=>10}
				puts uri
				res = Net::HTTP.get_response(uri,params)
				result = JSON.parse(res.body)
				   result.each{|args|
				     puts args
				   }
			end
			def method_name
				
			end

		end
		company = Company.new.create_company
	end
