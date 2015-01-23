module conf.app;

import dweb.router;
import vibe.http.common;

class AppConfig{

	RouteInfo*[] getRouteInfos()
	{
		auto routes = [
			new RouteInfo(HTTPMethod.GET, "/donglei/:name/:gender" , "200", "IndexController", "show", "controller.index"),
			new RouteInfo(HTTPMethod.GET, "/account/:action" , "200", "AccountController", ":action", "controller.account"),
			new RouteInfo(HTTPMethod.GET, "/index/:action" , "200", ":controller", ":action", "controller.index"),
		];
		return routes;
	}
}