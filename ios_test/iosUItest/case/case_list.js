#import "/Users/kr/autotest/ios_test/iosUItest/global.js"

test_news_list();
test_serch();
test_login_err();
target.delay(3);
test_login();
target.delay(2);
test_deep_service();
test_focus();
test_login_err_err();

//test_login_err();
//test_login();
//test_deep_service();
//test_focus();
//test_news_list();


//login_err(name="23300010006","abc123");
//target.delay(4);
//login_in(target);
//target.delay(4);
//news_list(target);