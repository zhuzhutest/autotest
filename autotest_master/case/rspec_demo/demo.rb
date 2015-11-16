require 'net/http'
require "json"

describe "request" do
	context "baidu" do
		context "index" do
			let(:result) { Net::HTTP.get(URI.parse('http://rong.test2.36kr.com/news')) }
			it "should respose 200" do
				json = JSON.parse(result)
				expect(json["code"]).to eq(0)
				expect(json["data"]["feeds"]).not_to be_empty
			end
		end
	end
	context "google" do
		it {} 
	end
end

