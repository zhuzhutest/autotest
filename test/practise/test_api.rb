require 'minitest/autorun'
require 'rest_client'
require 'json'

class APITest < MiniTest::Unit::TestCase
  def setup
    response = RestClient.get("http://i.baidu.com", 
      {
         "Content-Type" => "application/json",
         "Authorization" => "token 4d012314b7e46008f215cdb7d120cdd7",
         "Manufacturer-Token" => "8d0693ccfe65104600e2555d5af34213"
      }
    ) 
    @data = JSON.parse(response.body).to_s
  end

  def test_id_correct
    assert_equal 4, @data['id']
  end
end