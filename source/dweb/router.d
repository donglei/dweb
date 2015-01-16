module dweb.router;
import vibe.http.router;
import vibe.core.log;
import conf.app;
import std.conv;

//方法enum
enum RouteMethodEnum{
	get,
	post,
	delete_,
	put,
	fetch,
	any,
	rest,
	controller

}

struct RouteInfo{

	RouteMethodEnum method;
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
				case RouteMethodEnum.get:
					logInfo("method get");
					break;
				case RouteMethodEnum.post:
					logInfo("method post");
					break;
				default:
					logInfo("method " ~ to!string(route.method));
					break;
			}
		}
	}
}
