require 'net/pop'
require 'mail'
require 'watir'

# pop = Net::POP3.new('pop.126.com')
# pop.start('zhuzhutest@126.com', 'zhuzhu123')             # (1)
# if pop.mails.empty?
#   puts 'No mail.'
# else
#   #  # m.delete
#   #   i += 1
#   # end
#   file = []
#   file << pop.mails.pop.pop

#   puts "-----#{file[0]}"
#   puts "你好"
#   	# pop.mails.each do |m|

#   	# 	puts "#{m.pop.}"
#   	# 	File.open(m) do |file|
#   	# 		file.each_line { |line|
#   	# 			puts "aaaaa"
#   	# 		}
#   	# 	end
#   	#   end
#   puts "#{pop.mails.size} mails popped."
# end

#   #i = 0
#   # pop.mails.each do |m|   # or "pop.mails.each ..."   # (2)
#   #   File.open("inbox/#{i}", 'w') do |f|
#   #   	puts "#{f}"
#   #     f.write m.pop
#   #   end


Net::POP3.foreach( 'pop.126.com',
                     nil,     # using default (110)
                     'zhuzhutest@126.com',
                     'zhuzhu123' ) do |m|
	File.open("#{m.pop}", 'a') do |file|
		
	File.open("#{m.pop}", 'w') do |f|

puts  "aaaaa"
end
end
# Mail.defaults do
#   	retriever_method :pop3, 
#   		:address => "pop.163.com",
# 		:port => 110,
# 		:user_name  => "zhuzhutest@126.com",
# 		:password   => "zhuzhu123"
# 		# :enable_ssl => true
# end

# puts Mail.all.length
