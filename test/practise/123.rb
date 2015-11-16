require 'rubygems'
require 'json'
require 'net/http'
require 'pp'

def news_search(query, results=10, start=1)
   base_url = "http://api.map.baidu.com/place/v2/search?&q=%E5%A4%AA%E5%92%8C%E4%B8%AD%E5%AD%A6&region=%E9%87%8D%E5%BA%86&output=json&ak=lVur72ZX91U1ifStXQ7hT8bw"
   #url = "#{base_url}&query=#{URI.encode(query)}&results=#{results}&start=#{start}"
   #base_url = "http://"
   resp = Net::HTTP.get_response(URI.parse(base_url))
  # resp = Net::HTTP.get_response(URI.parse(base_url))
    #print resp.body
   data = resp.body

   # we convert the returned JSON data to native Ruby
   # data structure - a hash
   result = JSON.parse(data)
   result.each{|args|
     puts args
   }
   # if the hash has 'Error' as a key, we raise an error
   if result.has_key? 'Error'
      raise "web service error"
   end
   return result
end
news_search("mayun")