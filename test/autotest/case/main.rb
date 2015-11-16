require 'rubygems'
require File.dirname(__FILE__)+'/../run_case.rb'
#require File.dirname(__FILE__)+'/../global'

############## Debugging  ###############

tmp_casesuit = {"TEST_RECURSION" => %w[test_del_all_redirect]}
#/s
tmp_test_suit = [redirect_casesuit]
#,
############# Debugging  ################

is_first = true
    begin
        if is_first
            rt = RUN_TESTSUIT.new("chrome", "http://www.36kr.net/", "344264366@qq.com", "2359000", "test_all.log")
            rt.run_testsuit(tmp_test_suit)
            rt.close
            rt.write_log
            is_first = false
        else
            rt = RUN_TESTSUIT.new("chrome", "http://www.36kr.net/", "344264366@qq.com", "2359000", "test_all.log")
            rt.run_testsuit(tmp_test_suit)
            rt.write_log
        end
    rescue
        puts "err: #{$!} at #{$@.inspect}"
    ensure
        rt.close
        puts "all test case finished, sleep 20 seconds and run again..."
        puts "   ===  Run Case Complete!!!  ==="
    end
