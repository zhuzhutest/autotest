function test_login_err(){
	login_err("23300010006","abc111");
	login_err("23300010003","abcabc");
}
function test_login(){
	login_in("18901000000","280131305!kan");
}
function test_login_err_err(){
	test_login_err_err(username,password);
}
function test_logout(){
	login_out();
}