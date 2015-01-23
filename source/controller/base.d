module controller.base;
import std.stdio;
import vibe.d;
class BaseController : IController{

	mixin ControllerImplementation!();

	void say()
	{
		writeln(typeid(this));
	}
}

interface IController : MyDynamic{

	
}



public import std.variant;
import std.conv;
import std.traits;

// We want the callable thing to be an interface so it doesn't get in the way of multiple inheritance
interface MyDynamic {
	Variant callAction(string method, Variant[] arguments);
}

enum action; // we'll use this as a user-defined annotation to see if the method should be available

// This sees if the above attribute is on the member
bool isDynamicallyAvailable(alias member)() {

	// the way UDAs work in D is this trait gives you a list of them
	// they are identified by type and can also hold a value (though
	// we don't handle that case here)
	foreach(annotation; __traits(getAttributes, member))
		static if(is(annotation == action))
			return true;
	return false;
}

alias Helper(alias T) = T; // this is used just to help make code shorter when doing reflection

// then the implementation is a mixin template. This won't get in the way of inheritance
// and will run the template on the child class (putting the code straight in the interface or
// base class will not be able to call new methods in the children. The reason is this code runs
// at compile time, and at compile time it can only see what's there in the source - no child class methods.)
//
// Actually, I think there is a way to put a template like this in the interface that does know child classes,
// but I don't remember how or if it would actually work for this kind of thing or not. But I know this way works.
mixin template ControllerImplementation() {
	 public override Variant callAction(string methodNameWanted, Variant[] arguments) {
		foreach(memberName; __traits(allMembers, typeof(this))) {
			if(memberName != methodNameWanted)
				continue;

			// this static if filters out private members that we can see, but cannot access
			static if(__traits(compiles, __traits(getMember, this, memberName))) {

				// the helper from above is needed for this line to compile
				// otherwise it would complain that alias = __traits is bad syntax
				// but now we can use member instead of writing __traits(getMember) over and over again
				alias member = Helper!(__traits(getMember, this, memberName));

				// we're only interested in calling functions that are marked as available
				static if(is(typeof(member) == function) && isDynamicallyAvailable!member) {

					// now we have a function, so time to write the code to call it
					// gotta get our arguments converted to the right types. We get the
					// tuple of them, then loop over that, and extract it from our dynamic array.
					// We loop over the tuple because the compile time info is available there.
					ParameterTypeTuple!member functionArguments;

					// Note: This won't compile if the function takes fully immutable arguments!
					foreach(index, ref arg; functionArguments) {
						if(index >= arguments.length)
							throw new Exception("Not enough arguments to call " ~ methodNameWanted);

						// I did string arguments here, could be other things too
						//arg = to!(typeof(arg))(arguments[index]);

						// if you did Variant[] arguments, the following code would work instead
						 arg = arguments[index].get!(typeof(arg));
						// .coerce instead of .get tries to force a conversion if needed, so you might want that too
					}

					Variant returnValue="";

					// now, for calling the function and getting the return value,
					// we need to check if it returns void. If so, returnValue = void
					// won't compile, so we do two branches.
					static if(is(ReturnType!member == void))
					{
						member(functionArguments);
					}
					else
					{
						returnValue = member(functionArguments);
					}

					return returnValue;
				}
			}
		}

		throw new Exception("No such method " ~ methodNameWanted);
	}
}
