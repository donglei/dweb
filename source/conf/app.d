module conf.app;

import dweb.router;
import vibe.http.common;

class AppConfig{

	RouteInfo*[] getRouteInfos()
	{
		auto routes = [
			new RouteInfo(HTTPMethod.GET, "/donglei" , "200", "IndexController", "show", "controller.index"),
			
		];
		return routes;
	}
}