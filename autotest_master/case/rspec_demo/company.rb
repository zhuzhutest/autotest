require 'net/http'
require "json"
require "rspec"

describe Require do
	before do
		url = Net::HTTP.get(URI.parse('http://rong.test2.36kr.com/news/comments/532849')
	end
	context "get_comments" do
					let(:result) { Net::HTTP.get(URI.parse('http://rong.test2.36kr.com/news/comments/532849')) }
					it "should respose 200" do
					json = JSON.parse(result)
					expect(json["code"]).to eq(0)
					expect(json["data"]["feeds"]).not_to be_empty
			end
	end
end

class TestMeme