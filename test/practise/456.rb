require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

module KR_API
  module COMPANY
    extend self
          attr_accessor :context
          def self.set(context)
          end
          def self.json_parse(res_body)
              puts res_body
              result = JSON.parse(res_body)
              result.each{|args|
               puts args
             }
              return result
          end
          def self.get_response(uri)
              req = Net::HTTP::Get.new(uri)
              req['Cookie'] = "emember_user_token=W1s2OTFdLCIiXQ%3D%3D--165efd845f616dbd9b22d5427eec7fe202c1d27a; krid_user_version=5; krid_user_id=691; _auth_session=d83943f09c4123584fda3ba891e958f2; kr_plus_id=664; kr_plus_token=5c36f096215677890a2a62e36ed82b4adec4afe0; _ga=GA1.2.1379932843.1427682742"
              res = Net::HTTP.start(uri.hostname, uri.port){|http| http.request(req)}
              result = json_parse(res.body)
              return result
          end


      class GET
        KR_TEST = KR_API::COMPANY::GET.new
###############获取用户管理的公司###################
          def managed(args)
              r = ""
              uri = URI('http://rong.test.36kr.com/company?type=managed')
              result = COMPANY.get_response(uri)

             # if the hash has 'Error' as a key, we raise an error
               if result.has_key? 'Error'
                  raise "web service error"
                  r = "fafailed to web service"
               end
               if result["code"] == 0
                  r = result["code"]
                end
                  r = result["code"]
              return puts r
          end
          def test_managed
              r = []
              r.push(managed(:type => "managed"))
          end
          KR_TEST.test_managed
      end
      
  end

end