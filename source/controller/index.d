module controller.index;
import controller.base;

import std.stdio;
import vibe.d;


class IndexController : BaseController{
	
	mixin ControllerImplementation!();

	@action
	int show(HTTPServerRequest req, HTTPServerResponse res)
	{
		auto pageTitle = "董磊";
		//res.render!("index.dt",pageTitle,req);
		//render!("index.dt"); 不能直接使用render
		return 1;
	}

}