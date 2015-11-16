
function deep_service(){

test("deep service", function(tar,app){
     window_ = app.mainWindow();
     app.tabBar().buttons()["发现"].tap();
     window_.tableViews()[0].tapWithOptions({tapOffset:{x:0.25, y:0.32}});
     window_.tableViews()[0].dragInsideWithOptions({startOffset:{x:0.35, y:0.89}, endOffset:{x:0.29, y:0.18}, duration:3.0});
     window_.tableViews()[0].tapWithOptions({tapOffset:{x:0.32, y:0.68}});

     var company_name = window_.scrollViews()[0].staticTexts()["Trafree自由飞越"];
     assertNotNull(company_name,"Trafree自由飞越");
     tar.delay(5)
 //  app.navigationBar().tapWithOptions({tapOffset:{x:0.03, y:0.60}});
 //  app.navigationBar().leftButton().tap();
     });
}
function focus_company(){
test("focus company", function(tar,app){
     window_ = app.mainWindow();
//   app.tabBar().buttons()["我"].tap();
     window_.scrollViews()[0].buttons()["关注"].tap();
     var setting = window_.scrollViews()[0].buttons()["已关注"];
     assertNotNull(setting,"focus");
     });
}



