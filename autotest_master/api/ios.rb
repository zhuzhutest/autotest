require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'erb'
require File.dirname(__FILE__)+'/../global'
require File.dirname(__FILE__)+'/company'

module KR
  module API
  	module News
	  	def hello(name)
	  		puts "hello #{name}"
	  	end
		def get_news#########根据条件获取公司列表###########
            uri = URI('http://rong.test2.36kr.com/news')
            result = API.get_response(uri)
		end
		def get_comments(args)
			pid = args[:id]
			uri = URI("http://rong.test2.36kr.com/news/comments/#{pid}")
			result = API.get_response(uri)
		end
	
		def send_comments(args)
			cookie = args[:cookie]
			pid    = args[:pid]

			parame = {:uid => args[:uid] , :content => args[:content]}
			uri = URI("http://rong.test2.36kr.com/news/comments/#{pid}")
			result = API.post_response(uri, cookie, parame)
		end
		def news_search(args)
			parame ={:keyword => args[:keyword]}
			uri = URI("http://rong.test2.36kr.com/news/search")
			result = API.get_response(uri, parame)
		end
		end
	end
end
# news = KR::API::NEWS.new
news.get_news(:cookie => ENTREPRENEURS, :pid => 532603, :uid => 696, :content => "哎呦不错啊。哈哈哈哈")