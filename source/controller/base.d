module controller.base;
import std.stdio;

class BaseController : IController{
	void say()
	{
		writeln(typeid(this));
	}
}

interface IController{
	void say();
}