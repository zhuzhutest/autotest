# require File.dirname(__FILE__)+ '/../../api/ios'
require File.dirname(__FILE__)+ '/../../api/company'
require File.dirname(__FILE__)+'/../../global'



class TEST_COMPANY
	COMPANY_TEST = KR::API::COMPANY.new
	def test_company_list
		r = []
		arr = [0,1,2]
		arr.each {|fincestatus|
		r.push(COMPANY_TEST.company_list(:cookie => INVESTOR, :fincestatus => fincestatus, :type => 0, :page => 1))#####融资中1，融资完成2，全部公司0########
		}
		r.push(COMPANY_TEST.company_list(:cookie => HIGH_INVESTOR, :tpye => 1))
	end
	def test_count_all
		r = []
		r.push(COMPANY_TEST.count_all(:cookie => HIGH_INVESTOR))
		r.push(COMPANY_TEST.count_all(:cookie => INVESTOR))
	end
	def test_count_common
		r = []
		r.push(COMPANY_TEST.count_common(:cookie => ENTREPRENEURS))
		r.push(COMPANY_TEST.count_common(:cookie => INVESTOR))
	end
	def test_get_company
		r = []
		r.push(COMPANY_TEST.get_company(:cookie => HIGH_INVESTOR, :cid => 131706))
		r.push(COMPANY_TEST.get_company(:cookie => INVESTOR, :cid => 131868))
	end
	def test_check_company
		r = []
		r.push(COMPANY_TEST.check_company(:cookie => HIGH_INVESTOR, :name => "qiguo"))
		r.push(COMPANY_TEST.check_company(:cookie => HIGH_INVESTOR, :name => "燕国"))
		r.push(COMPANY_TEST.check_company(:cookie => HIGH_INVESTOR, :name => "xiaodoudoudoudoudoud"))
	end
	def test_update_company
		r = []
		r.push(COMPANY_TEST.update_company(:cookie => HIGH_INVESTOR, :cid => 131962, :website => "http://www.baidu.com", :brief => "第一次修改", :industry => "AUTO", :operationStatus => "OPEN"))
		r.push(COMPANY_TEST.update_company(:cookie => HIGH_INVESTOR, :cid => 131962, :website => "http://www.sohu.com", :brief => "第二次修改", :industry => "AUTO", :operationStatus => "OPEN"))

	end
	def test_set_managed
		r = []
		r.push(COMPANY_TEST.set_managed(:cookie => HIGH_INVESTOR, :cid => 131706, :manager => 696))
		r.push(COMPANY_TEST.set_managed(:cookie => INVESTOR, :cid => 131706, :manager => 664))
	end
	def test_claim_company
		r = []
		r.push(COMPANY_TEST.claim_company(:cookie => HIGH_INVESTOR, :cid => 131972, :type => "FOUNDER"))
	end
	def test_create_company
		r = []
		r.push(COMPANY_TEST.create_company(:cookie => HIGH_INVESTOR, :name => "测试接口", :brief => "测试接口demo" , :type => "FOUNDER" , :position => "CEO" , :startDate => "2013-05-01 12:00:00" , :endDate => ""))
	end
	def test_create_fast
		r = []
		2.times do
			r.push(COMPANY_TEST.create_fast(:cookie => INVESTOR, :mode => 'fast', :name => '亮亮测试1' , :brief => 'adasdfasdfasdasfdasdf', :companySource => "" ))
		end
		r.push(COMPANY_TEST.create_fast(:cookie => INVESTOR, :mode => 'fast', :name => '测试公司1' , :brief => 'abcdefggsadfa'))
	end
	def test_get_managed
		r = []
		r.push(COMPANY_TEST.get_managed(:cookie => INVESTOR))
	end
	# def test_funds
	# 	r = []
	# 	http://rong.test.36kr.com/api/company/132160/funds?action=rejected
		
	# end
	# diao = 	TEST_COMPANY.new
	# diao.test_create_company
	
end
# class TEST_IOS_NEWS
# 	KR_IOS_NEWS = KR::API::IOS_NEWS.new
# 	def test_news_search
# 		r = []
# 		r.push(KR_IOS_NEWS.news_search(:keyword => "wink hub"))
# 	end

# end
