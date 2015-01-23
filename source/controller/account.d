module controller.account;

import controller.base;
import std.stdio;
import vibe.d;

class AccountController : BaseController{

	mixin ControllerImplementation!();

	@action
	int detail(HTTPServerRequest req, HTTPServerResponse res)
	{
		//TODO code
		auto pageTitle = "董磊Account";
		res.writeBody(pageTitle);
		//render!("index.dt"); 不能直接使用render
		return 0;
	}
}