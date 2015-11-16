require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'erb'
require File.dirname(__FILE__)+'/../global'

module KR
  module API
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
              return check_result(result)
          end
          def self.get_response(uri, cookie=nil, parame=nil)
            if parame != nil
               uri.query = URI.encode_www_form(parame)
            end
              req = Net::HTTP::Get.new(uri)
            if cookie != nil
              req['Cookie'] = cookie
            end
              res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req)}
              result = json_parse(res.body)
              return result
          end
          def self.post_response(uri, cookie, parame=nil)
              req = Net::HTTP::Post.new(uri)
              req.set_form_data(parame)
              req['Cookie'] = cookie
              res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req)}
              result = json_parse(res.body)
              return result
          end
          def self.put_response(uri,cookie,parame=nil)
              req = Net::HTTP::Put.new(uri)
              if parame != nil
                  req.set_form_data(parame)
              end
              req['Cookie'] = cookie
              res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req)}
              result = json_parse(res.body)
              return result
          end
          def check_result(result)
              r = ""
              if result.has_key? 'Error'
                  r += "failed to web service error"
               end
               if result["code"] == 0
                  r += "succeed to test the company?#{}" +"\s" + result["code"].to_s
               else
                  r += "failed to test the company?type=managed" +"\s" + result["code"].to_s
               end
               puts r
              return r
          end


      class COMPANY
          def company_list(args)#########根据条件获取公司列表###########
              cookie = args[:cookie]
              uri = URI('http://rong.test.36kr.com/company/')

              parame = {"fincestatus" => args[:fincestatus], 'type' => args[:type], 'page' => args[:page]}
              result = API.get_response(uri, cookie, parame)
          end
          def count_all(args)###获取全部融资公司个数（对优质投资人可见的和不可见的)##############
              r = ""
              cookie = args[:cookie]
              uri = URI('http://rong.test.36kr.com/company/count-all')
              result = API.get_response(uri, cookie)
          end
          def count_common(args)#########获取普通融资公司个数（对非优质投资人可见的)###########
              r = ""
              cookie = args[:cookie]

              uri = URI("http://rong.test.36kr.com/company/count-common")
              result = API.get_response(uri, cookie)
          end
          def get_company(args)########获取公司的基本信息，介绍，链接，融资信息，标签###########
              r = ""
              cookie = args[:cookie]
              cid    = args[:cid]

              uri = URI("http://rong.test.36kr.com/company/#{cid}")
              result = API.get_response(uri, cookie)
          end
          def check_company(args)#######根据名称检查公司是否可创建，如果已有同名的公司，则返回它的数据##########
              r = ""
              cookie = args[:cookie]
              parame = {"action" => "checkName", "name" => args[:name]}

              uri = URI("http://rong.test.36kr.com/company")
              result = API.get_response(uri, cookie, parame)
          end
          def get_managed(args)###获取用户管理的公司########
              r = ""
              cookie = args[:cookie]
              uri = URI('http://rong.test.36kr.com/company?type=managed')
              result = API.get_response(uri, cookie)
          end
          def create_fast(args)######快速创建公司########
              r = ""
              cookie = args[:cookie]
              parame = {'mode' => args[:mode] , 'name' => args[:name] , 'brief' => args[:brief], :companySource => args[:companySource]}
              puts parame
              uri = URI("http://rong.test.36kr.com/company")
              result = API.post_response(uri, cookie, parame)
          end
          def update_company(args)######更新公司信息########
              r = ""
              cookie = args[:cookie]
              cid    = args[:cid]
              parame = {'website' => args[:website], 'brief' => args[:brief], 'industry' => args[:industry], 'startDate' => args[:startDate], 'operationStatus' => args[:operationStatus]}
              uri = URI("http://rong.test.36kr.com/company/#{cid}")
              result = API.put_response(uri, cookie, parame)
          end
          def set_managed(args)######设置管理员#########
              r = ""
              cookie = args[:cookie]
              cid    = args[:cid]
              parame = {'manager' => args[:manager]}
              uri = URI("http://rong.test.36kr.com/company/#{cid}")
              result = API.put_response(uri, cookie, parame)
          end
          def claim_company(args)#####认领公司#########
              r = ""
              cookie = args[:cookie]
              cid    = args[:cid]
              parame = {'type' => args[:type]}
              uri = URI("http://rong.test.36kr.com/company/#{cid}?action=claim")
              result = API.put_response(uri, cookie, parame)

          end
          def create_company(args)######正常创建公司－进入草稿模式###########
              r = ""
              cookie = args[:cookie]
              parame = {'name' => args[:name], 'brief' => args[:brief], 'type' => args[:type], 'position' => args[:position], 'startDate' => args[:startDate], 'endDate' => args[:endDate]}
              uri = URI("http://rong.test.36kr.com/company/")
              result = API.post_response(uri, cookie, parame)
          end
          def post_user
              parame = {:tpye => "email", :email => "zhuzhutest111@163.com", "name" => "测试"}
              uri = URI("http://rong.dev.36kr.com/api/user/invite")
              result = API.post_response(uri, parame)
          end
          # diao = COMPANY.new
          # diao.create_company

      end
  end
end