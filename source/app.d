import vibe.d;
import vibe.http.router;
import vibe.core.log;
import std.stdio;
import dweb.router;
import conf.app;
import dweb.common;
import controller.base;
import dweb.templateparse;
import dweb.templatelib;
import dweb.templatesupport;
import std.traits;


shared static this()
{
	setLogFile("dweb.log", LogLevel.diagnostic);

	auto router = new URLRouter;
	//auto appConfig = new AppConfig();//路由等其他设置
	//处理自定义路由
	//router.registerDwebRouter(appConfig.getRouteInfos());

	router.get("/static/*", serveStaticFiles("public/"));



	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1", "0.0.0.0"];
	//listenHTTP(settings, router);
	listenHTTP(settings, &hello);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	// Context ====================

	int[] intarray = [1, 2, 3, 4];
	Variant[] vararray = [Variant(1), Variant(2.12), Variant(true), Variant("polompos")];
	string[] stringarray = ["pok", "polompos", "cogorcios", "foo", "bar"];
	int[string] assocarray1 = ["pok": 1, "polompos": 2];
	string[int] stringintarray = [1: "pok", 6: "polompos"];

	string[string][] listassoc;
	listassoc.length = 2;
	listassoc[0] = ["polompos": "pok", "malo": "bueno"];
	listassoc[1] = ["uno": "dos", "tres": "seis"];

	string[int][] listassocint;
	listassocint.length = 2;
	listassocint[0] = [1: "pok", 7: "bueno"];
	listassocint[1] = [3: "dos", 5: "seis"];

	Variant[string] assocvariant = ["uno": Variant(1), "true": Variant(true)];

	Variant[string][] listvarassoc;
	listvarassoc.length = 2;
	listvarassoc[0] = ["uno": Variant(1), "dos": Variant(2)];
	listvarassoc[1] = ["true": Variant(true), "pi": Variant(3.14)];

	string[][] listliststring = [["uno", "dos", "tres", "cuatro"], ["a", "be", "ce", "de"]];

	auto bi = new CommandInfo("nombre", "parametros");
	bi.text = "texto";

	// End context ===============================
	Variant[string] context =      [
		"testvarint":    Variant(42),
		"testvarfloat":  Variant(3.14),
		"testvarstring": Variant("polompos <> & \""),
		"testvarbool":   Variant(true),
		"intarray":      Variant(intarray),
		"vararray":      Variant(vararray),
		"stringarray":   Variant(stringarray),
		"stringintarray":Variant(stringintarray),
		"assocarray1":   Variant(assocarray1),
		"listassoc":     Variant(listassoc), 
		"listassocint":  Variant(listassocint),
		"assocvariant":  Variant(assocvariant),
		"class"       :  Variant(bi),
		"listliststring":Variant(listliststring),
		"listvarassoc":  Variant(listvarassoc),
		"cycle1":        Variant("cycle_first"),
		"cycle2":        Variant("cycle_second"),
		"cycle3":        Variant("cycle_third"),
		"alias":         Variant("aliasfuerawith"),
	];

	auto contextobj = new TemplateContext(context);

	DJTemplateParser parser = null;
	parser = new DJTemplateParser("index.html", ["./views"], contextobj, Yes.LoadOptimized);
	parser.render();

	auto result = parser.result;
	res.writeBody(result);
}
