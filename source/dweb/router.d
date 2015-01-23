module dweb.router;
import vibe.http.router;
import vibe.core.log;
import conf.app;
import std.conv;
import vibe.http.common;
import vibe.http.form;
import controller.base;
import vibe.web.common;
import std.typecons;
import std.string;

import std.stdio;

struct RouteInfo{
	HTTPMethod method;// e.g. GET
	string Path;              // e.g. /app/:id
	string Action;            // e.g. "Application.ShowApp", "404"
	string ControllerName;    // e.g. "Application", ""
	string MethodName ;       // e.g. "ShowApp", ""
	string ModuleName;		//modual controller.index
		
}

DwebRouter registerDwebRouter(URLRouter router, RouteInfo*[] routers)
{
	auto dwebRouter = new DwebRouter(router, routers);
	dwebRouter.initRouters();
	return dwebRouter;
}

class DwebRouter{

	private RouteInfo*[] routInfo;
	private URLRouter router;

	this(RouteInfo*[] routers)
	{
		this.routInfo=routers;
	}

	this(URLRouter router, RouteInfo*[] routers)
	{
		this(routers);
		this.router = router;
	}


	void initRouters()
	{
		if(this.routInfo is null)
		{
			logInfo("routeinfo is null");
			return ;
		}
		foreach( route ; this.routInfo)
		{
			void handler(HTTPServerRequest req, HTTPServerResponse res)
			{
				
				import std.variant;
				import std.uni;
				import std.string;
				//检查module controller action 是否存在
				//importModule!(route.ModuleName);
				
			
				auto controllName = route.ControllerName ==":controller" ? this.getControllerName(req.params["controller"]) : route.ControllerName;
				auto actionName = route.MethodName ==":action" ? this.getActionName(req.params["action"]) : route.MethodName;
				enforceBadRequest(false, "No method found that matches the found form data:\n Module:"~route.ModuleName~", Controller:"~controllName~",Action:"~actionName);
				//try{
					auto controller = this.findController(route.ModuleName ~ "." ~ controllName);
					auto params=variantArray(req,res);
					auto result = controller.callAction(actionName, params);
				////}catch{
					enforceBadRequest(false, "No method found that matches the found form data:\n Module:"~route.ModuleName~", Controller:"~controllName~",Action:"~actionName);
				//}
			}

			switch(route.method){
				case HTTPMethod.GET:
					this.router.get(route.Path, &handler);
					break;
				case HTTPMethod.POST:
					logInfo("method post");
					break;
				default:
					logInfo("method " ~ to!string(route.method));
					break;
			}
		}
	}
	const IController findController(string class_name)
	{
		//const ClassInfo c = ClassInfo.find(class_name);
		//return c.create();
		auto controller = cast (IController)Object.factory(class_name);
		return controller;
	}
	//获取格式化的ControllerName index => IndexController
	private string getControllerName(string controllerName)
	{
		return capitalize(controllerName)~"Controller";
	}
	////获取格式化的ControllerName index => IndexController
	private string getActionName(string actionName)
	{
		return toLower(actionName);
	}

 
}

template importModule(string moduleName)
{
	mixin("import "~moduleName~";");
}