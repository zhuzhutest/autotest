$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))
require 'date'
#require 'net/ssh'
require 'timeout'

require File.dirname(__FILE__)+'/KR'
require File.dirname(__FILE__)+'/mail'
#require File.dirname(__FILE__)+'/global'

#MAIL_PICTURE_FUNC = { "TEST_LOGIN"=>["TEST"], "TEST_DNS" => ["test_edit_soa", "test_create_zone", "test_create_domain"], "TEST_SYSTEM"=>["test_auto_backup"], "TEST_AD"=>["test_add_ad"], "TEST_RECURSION"=>["test_create_forward_zone", "test_create_redirect"]}
class RUN_TESTSUIT
    @@all_suit_info = ""
    @@all_case_info = ""
    @@all_stream_info = ""
    @@starttime = nil
    @@stream_succ_num = 0
    @@stream_fail_num = 0
    @@is_mail_send = true 
    @@run_times = 0
    @@case_total = 0
    @@skip_case = []
	def initialize(brow, site, user, password, filename)
		KR.init_browser(brow)
		KR::Login::Login.new.login(site, user, password)
        @case_info = @@all_case_info
        @suit_info = @@all_suit_info
        @stream_info = @@all_stream_info
        @filename = filename
        @sts = Stream_stats.new()
        @sts.succ = @@stream_succ_num
        @sts.fail = @@stream_fail_num
	end
    def close
        @@all_suit_info = @suit_info
        @@all_case_info = @case_info
        @@all_stream_info = @stream_info
        @@stream_succ_num = @sts.succ
        @@stream_fail_num = @sts.fail
        KR.browser.close
    end

	def run_case(className, funcName)
        puts "test case #{className}, #{funcName}"
        screen_file_name = File.dirname(__FILE__)+'/case/log/' + className + '_' + funcName + '.png'
        cs = Case_stats.new
		begin
			Dir[File.dirname(__FILE__)+'/case/*.rb'].each {|file| 
				if file.match(className.downcase) then
					require file
				end
			}
			k = Kernel.const_get(className).new()
			if k.respond_to?(funcName) then
                cs.name = funcName
  				rl = k.send(:funcName)
  				rl.each {|r|
  					if r.include?("succeed") and !r.include?("failed") then
                        cs.add_succ
                        @case_info += "\t#{funcName} pass\n"
                        r.split("\n").each {|res|
                            @@case_total += 1
                            @case_info += "\t\t#{res}\n"
                        }
                    KR.screen(screen_file_name)
  				    else
                        cs.add_fail
                        content = "\t#{funcName} fail\n"
                        r.split("\n").each {|res|
                            content += "\t\t#{res}\n"
                            @@case_total += 1
                        }
                        @case_info += content
                        KR.screen(screen_file_name)
                        KR::send_mail(content, FROM_MAIL, TO_MAIL)
  				    end
  			    }
  			else
                puts "class: #{className} has not function: #{funcName}, please check"
                @@skip_case << funcName
			end 
            @case_info = cs.info + @case_info
            puts cs.info
            return cs
        rescue SyntaxError => e
            puts e
            exit
		rescue 
			puts "----error at: #{$@.inspect}\n"
			puts "----error: #{$!}\n"
			KR.browser.refresh
	        run_case(className, funcName)
        end
	end


	def run_casesuit(casesuit)
        ss = Suit_stats.new
        casesuit.each_pair{ |className, func_list|
                ss.name = className.downcase
				func_list.each{|func|
					cs = run_case(className, func)
                    if cs.total == cs.succ
                        ss.add_succ
                    else
                        ss.add_fail
                    end
				}
                @suit_info += ss.info
        }
        puts ss.info
        return ss
	end
    end
	def run_testsuit(testsuit)
        @@starttime = DateTime.now if !@@starttime
		testsuit.each{|cs|
		    ss = run_casesuit(cs)
            ss.total == ss.succ ? @sts.add_succ : @sts.add_fail
		}
	end
    def write_log
		@f = File.new(File.dirname(__FILE__)+'/case/log/'+@filename, "a+")
	    @f_cur = File.new(File.dirname(__FILE__)+'/case/log/last_messages.log', "w")
		@f.puts "------------------------------------------------------------------------------------------------------------"
        run_result = "!!!start test #{@@starttime.strftime("%Y-%m-%d %H:%M:%S")}"
        run_result += "total cases: #{@@case_total}\n"
        run_result += "skip case is: #{@@skip_case.to_s}\n"
        @sts.name = "TEST_KR"
        if @sts.succ == @sts.total 
            run_result += "\nall test case pass\n" 
        else
            run_result += "there is #{@sts.fail} failed!!!\n\n" 
            run_result += "detail as follows:\n" 
        end
        @stream_info += @sts.info
        run_result += @stream_info
        run_result += @suit_info
        run_result += @case_info
		t = DateTime.now
        run_result += "!!!end test #{t.strftime("%Y-%m-%d %H:%M:%S")}"
        @f.puts run_result
		@f.puts "-----------------------------------------------------------------------------------------------------------\n"
        @f_cur.puts run_result
        @f.close
        @f_cur.close
        @@is_mail_send = true if @@run_times % 10 == 0
        if @@is_mail_send
            attachment = []
            MAIL_PICTURE_FUNC.each_pair{ |className, funclist|
                    funclist.each {|funcName|
                        attachment << File.dirname(__FILE__) + '/case/log/' + className + '_' + funcName + '.png'
                    }
            }
            KR::send_mail(run_result, FROM_MAIL, TO_ALL_MAIL, attachment)
            @@is_mail_send = false
        end
        reinit_data
        @@run_times += 1
    end
    def reinit_data
         @@starttime = nil
         @@all_suit_info = ""
         @@all_case_info = ""
         @@all_stream_info = ""
         @@stream_succ_num = 0
         @@stream_fail_num = 0
         @@case_total = 0
         @@skip_case = []
         @suit_info = ""
         @case_info = ""
         @stream_info = ""
         @sts.succ = 0 
         @sts.fail = 0 
    end
    class Stats
        attr_accessor(:succ, :fail, :name)
        def initialize()
            @succ = 0
            @fail = 0
            @name = ''
        end
        def add_succ
            @succ += 1
        end
        def add_fail
            @fail += 1
        end
        def total
            @succ + @fail
        end
    end
    class Stream_stats < Stats
        def info
            "total:%3s%4ssucc:%3s%4sfail:%3s%4sStream:%4s%s\n" % [total, " ", @succ, " ", @fail, " ", " ", @name]
        end
    end
    class Suit_stats < Stats
        def info
            "total:%3s%4ssucc:%3s%4sfail:%3s%4sClass:%5s%s\n" % [total, " ", @succ, " ", @fail, " ", " ", @name]
        end
    end
    class Case_stats < Stats
        def info
            "total:%3s%4ssucc:%3s%4sfail:%3s%4sFunction:%2s%s\n" % [total, " ", @succ, " ", @fail, " ", " ", @name]
        end
    end
#end
if __FILE__ == $0
    10.times { |i|
    st = RUN_TESTSUIT::Stream_stats.new
    st.name = ("TEST_ST%019d" % i).downcase
    puts st.info
    st = RUN_TESTSUIT::Suit_stats.new
    st.name = "SUITs%012d" % i
    puts st.info
    st = RUN_TESTSUIT::Case_stats.new
    st.name = "CASE%03d" % i
    puts st.info
    }
end

