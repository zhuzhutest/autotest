function news_list(sheet){
	test("new_list", function(tar,app){
		var window_ = app.mainWindow();
		//app.tabBar().buttons()["新闻"].tap();
		window_.scrollViews()[1].buttons()[sheet].tap();
		var sheet_name = app.windows()[0].scrollViews()[0].collectionViews()[0].cells()["Nicholas 2小时前"].staticTexts()["O2O"];
		assertNotNull(sheet, "suss");
		});
}

function serch(name){
	test("serch", function(tar,app){
		var window_ = app.mainWindow();
		app.navigationBar().buttons()[1].tap();
		app.keyboard().typeString(name);
		var user_name = app.windows()[0].collectionViews()[0].cells()[1].staticTexts()[0].name();
		assertEquals(user_name,name,"suss");
		window_.buttons()["取消"].tap();
	});
}
