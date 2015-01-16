module conf.app;

import dweb.router;

class AppConfig{

	RouteInfo*[] getRouteInfos()
	{
		auto routes = [
			new RouteInfo(RouteMethodEnum.get),
			new RouteInfo(RouteMethodEnum.get),
			new RouteInfo(RouteMethodEnum.post),
			new RouteInfo(RouteMethodEnum.controller),
		];
		return routes;
	}
}