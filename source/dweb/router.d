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
			switch(route.method){
				case HTTPMethod.GET:
					auto controller = this.findController(route.ModuleName ~ "." ~ route.ControllerName);
					this.registerCustomRouteInterface(controller, route.Path, route.MethodName);
					writeln(controller.toString(), route.Path, route.MethodName);
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
	const Object findController(string class_name)
	{
		const ClassInfo c = ClassInfo.find(class_name);
		return c.create();
	}

	void registerCustomRouteInterface(I)(I instance, string url_prefix, string method)
	{

		
		import std.stdio;
		void handler(HTTPServerRequest req, HTTPServerResponse res)
		{
			import std.traits;
			//		alias MemberFunctionsTuple!(T, method) overloads;
			string errors;
			foreach(func; __traits(getVirtualMethods,instance, method)) {
				string error;
				ReturnType!func delegate(ParameterTypeTuple!func) myoverload=&__traits(getMember, instance, method);
				if(applyParametersFromAssociativeArray!func(req, res, myoverload, error, strict)) {
					return;
				}
				errors~="Overload "~method~typeid(ParameterTypeTuple!func).toString()~" failed: "~error~"\n\n";
			}
			enforceBadRequest(false, "No method found that matches the found form data:\n"~errors);
		}

		router.get(url_prefix, &handler);

	}
 
}
