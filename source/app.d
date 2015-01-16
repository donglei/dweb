import vibe.d;
import vibe.http.router;
import vibe.core.log;

import dweb.router;
import conf.app;

shared static this()
{
	setLogFile("dweb.log", LogLevel.diagnostic);

	auto router = new URLRouter;
	auto appConfig = new AppConfig();//路由等其他设置
	//处理自定义路由

	router.registerDwebRouter(appConfig.getRouteInfos());

	router.get("*", serveStaticFiles("./public/"));

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1", "0.0.0.0"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello, World!");
}
