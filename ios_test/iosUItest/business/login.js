
function login_err(username,password){

test("login err", function(tar,app){
     window_ = app.mainWindow();
     app.tabBar().buttons()["我"].tap();
     window_.tableViews()[0].cells()["未登录"].tap();
     window_.textFields()[0].tap();
     app.keyboard().typeString(username);
     window_.secureTextFields()[0].tap();
     app.keyboard().typeString(password);
     window_.buttons()["登录"].tap();
     var setting = window_.staticTexts()["帐号或密码错误"];
     assertNotNull(setting,"login err suss");
     app.navigationBar().leftButton().tap();
     });
}
function login_err_err(username,password){
     test("test login err",function(target,app){
     app.tabBar().buttons()["我"].tap();
     window_.tableViews()[0].cells()["未登录"].tap();
     window_.textFields()[0].tap();
     app.keyboard().typeString("23300010000000");

     var disable = window_.buttons()["登录"].isEnabled();
     assertFalse(disable,"suss");
     target.delay(3);
     window_.secureTextFields()[0].tap();
     window_.textFields()[0].buttons()["login icon delete"].tap();
     });

}
function login_in(username,password){
test("login in", function(tar,app){
     window_ = app.mainWindow();
  //   app.tabBar().buttons()["我"].tap();
     window_.tableViews()[0].cells()["未登录"].tap();
     window_.textFields()[0].tap();
     app.keyboard().typeString(username);
     window_.secureTextFields()[0].tap();
     app.keyboard().typeString(password);
     window_.buttons()["登录"].tap();
     var setting = window_.tableViews()[0].cells()["设置"];
     assertNotNull(setting,"login suss");
     });
}
// //target.delay(4);



