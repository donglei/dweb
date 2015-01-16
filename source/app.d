import vibe.d;
import vibe.http.router;

shared static this()
{
	auto router = new URLRouter;
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1", "0.0.0.0"];
	listenHTTP(settings, &hello);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello, World!");
}
