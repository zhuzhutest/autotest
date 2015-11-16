require File.dirname(__FILE__)+ '/../../api/ios'
require File.dirname(__FILE__) + '/../../global'
require File.dirname(__FILE__)+ '/../../api/company'
#require 'minitest/autorun'

class TEST_IOS_NEWS
	include KR::API::News

	# KR_IOS_NEWS = News.new
	def test_news_search
		self.ooxx
		helle "you"
		# r = []
		# r.push(KR_IOS_NEWS.news_search(:keyword => "wink hub"))
	end
	def test_get_news
		r = []
		r.push(KR_IOS_NEWS.get_news)
	end

	# diao = TEST_IOS_NEWS.new
	# diao.test_get_new

end