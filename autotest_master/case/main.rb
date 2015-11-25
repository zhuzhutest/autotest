require 'rubygems'
require File.dirname(__FILE__)+'/../run_case.rb'
#require File.dirname(__FILE__)+'/../global'
# TEST_IOS_NEWS.new

##############  UI #######################/s
ui_casesuit = {"TEST_PROJECT" => %w[test_creat_project]}

##############  UI #######################

############## API #######################

company_casesuit = {"TEST_COMPANY" => %w[test_company_list test_count_all test_count_common test_get_company test_check_company  test_get_managed test_create_company test_set_managed test_claim_company test_update_company test_create_fast ]}
#company_product_casesuti = {"TEST_COMPANY_PRODUCT" => %w[]}



ios_api_casesuit = {"TEST_IOS_NEWS" => %w[test_news_search test_get_new]}
############## API #######################



############## Debugging  ######################

tmp_casesuit1 = {"TEST_COMPANY" => %w[test_company_list test_count_all test_count_common test_get_company test_check_company test_update_company]}
tmp_casesuit = {"TEST_COMPANY" => %w[test_create_fast]}
############## Debugging ######################

# redirect_casesuit = {"TEST_RECURSION" => %w[test_del_all_redirect test_del_view]}

tmp_test_suit = [tmp_casesuit]

# after_restart_testsuit = [dns_after_restart_casesuit, dns_del_casesuit]

############# Debugging  ################





is_first = true
    begin
     if is_first
        rt = RUN_TESTSUIT.new(nil, nil, nil, nil, "test_api_all.log")
       # rt = RUN_TESTSUIT.new(log_name: "test_api_all.log")
        rt.run_testsuit(tmp_test_suit)
        rt.write_log
        is_first = false
    end
    rescue
        puts "err: #{$!} at #{$@.inspect}"
    ensure
        puts "all test case finished, sleep 20 seconds and run again..."
        puts "   ===  Run Case Complete!!!  ==="
    end