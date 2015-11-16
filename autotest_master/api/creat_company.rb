require 'rubygems'
require 'json'
require 'net/http'

CHEN = "kr_stat_uuid=MbAt423866721; kr_plus_id=11788; kr_plus_token=e1d62c73d8be4cbb85f7ab052aa134f55ec51c83; _gat=1; _ga=GA1.2.635728409.1432003315; Hm_lvt_e8ec47088ed7458ec32cde3617b23ee3=1431939970,1431997639,1432007152; Hm_lpvt_e8ec47088ed7458ec32cde3617b23ee3=1432007160; krchoasss=eyJpdiI6Iks1TE9RU055TGRKRTByWUhkM2RSdVE9PSIsInZhbHVlIjoiVGVrQ0hVOXlleTdKaHpiM0VLUFwvdWw4Y0ducnN4S2trVTFNcjN1bTUxaXowbDdqMXBBY0NWbFpoYmZzRjNQUTBXMWFIc2d1bDZ3aTRPTnlIUW5yaG9nPT0iLCJtYWMiOiI1YTMxNzU3Y2IyNzg5MzZlMzhkNTRjNTY1M2EyOTc4YTYxNDYwNWQxZWFmYzcxN2RhNjY5ZGVhNmI1ZjM3NmFkIn0%3D; _krypton_session=c867fa19ef1c5e584953425a90dc6e37; krid_user_version=6; krid_user_id=184997; _auth_session=a09db924a0ce9b543b0d9c1df3dd65ad"
LIJING = "_gat=1; kr_plus_id=11780; kr_plus_token=8406f8c1ecec8e376d0486b1aa1af68b61cfee3c; kr_stat_uuid=SQnTN23866788; _ga=GA1.2.1564188536.1432007269; Hm_lvt_e8ec47088ed7458ec32cde3617b23ee3=1431939970,1431997639,1432007152; Hm_lpvt_e8ec47088ed7458ec32cde3617b23ee3=1432007317; _krypton_session=3915de7276516bc4acc58d420f0a8289; krchoasss=eyJpdiI6Imt6djRYYU5kYm9QNG9PMDdzUEVLMlE9PSIsInZhbHVlIjoiWk10UW9aUkpvcjZVUTZiY3ZcL2hyN3ZDQ3FuTG9JQXNTUG03V2FLaFpuZGlMZ1hhUDNSd25jK1FcL3hpd2tmQzNiVmowajh3ajJwV3BcL1NjNlhvV1luSXc9PSIsIm1hYyI6ImM5ZjhiZWU4MzM2MDQ1NjlkMWZlMDM2MDljYjBjNjQwMjgwZTQ2MDRhOTNmYzA4YmE2MWIxMDkxZjQwNTg1NzcifQ%3D%3D; krid_user_version=2; krid_user_id=182864; _auth_session=d258263a83aa08753973f949497e93a1"

def self.json_parse(res_body)
	puts res_body
	result = JSON.parse(res_body)
	result.each{|args|
		puts args
	}
	return result
end

def creat_company(args)
	cookie = args[:cookie]
	uri = URI.parse("http://rong.dev.36kr.com/api/company")
	params = {:mode => args[:mode], :name => args[:name] , :brief => args[:brief], :position => args[:position],:companySource => args[:companySource] ,:startDate => args[:startDate]}
	result = post_response(uri, cookie, params)
end
def post_response(uri, cookie, parame=nil)
	req = Net::HTTP::Post.new(uri)
	req.set_form_data(parame)
	req['Cookie'] = cookie
	res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req)}
	puts "aaaaaaaa" + res.body
	puts "bbbbbbbb" + res.code
	#result = json_parse(res.body)
    #return result
end
def test_create_fast
	r = []
	2.times do |i|
		name = "测试众筹chen#{i}"
		puts name
		creat_company(:cookie => CHEN, :mode => 'fast', :name => "#{name}" , :brief => 'adasdfasdfasdasfdasdf',:position => "FOUNDER", :companySource => "INDIVIDUAL_STARTUP_EXPERIENCE_CREATION", :startDate => "2013-05-01 12:00:00")
	end
	# 2.times do |i|
	#name = "测试众筹jing#{i}"
	#puts name
	# 	r.push(create_company(:cookie => LIJING, :mode => 'fast', :name => '众筹测试公司JING' , :brief => 'abcdefggsadfa',:companySource => "INDIVIDUAL_STARTUP_EXPERIENCE_CREATION"))
	# end
end
test_create_fast


#http = Net::HTTP.new(uri, uri.port)
# res = Net::HTTP.post_form(uri, params)

# puts res.code
# data = res.body
# result = JSON.parse(data)
# result.each{|args|
#  puts args

# Net::HTTP.start(uri.host, uri.port) do |http|
#   request = Net::HTTP::Get.new uri

#   response = http.request request # Net::HTTPResponse object
# end


