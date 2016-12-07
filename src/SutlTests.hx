
@:expose
class SutlTests 
{
	public static function RunTests()
	{
		var r = new haxe.unit.TestRunner();
	  	r.add(new TestsHelloWorld());
	  	r.add(new TestsGet());
	  	r.add(new Tests_isType());
	  	r.add(new Tests_Paths());
	  	r.add(new Tests_Builtins());
	  	r.add(new Tests_Evaluate());
	  	r.add(new Tests_Decls());
	  	
	  	r.run();
	  	
	  	if (!r.result.success)
	  	{
	  		trace("failure");
	  		throw r.result.toString();
	  	}
	  	else
	  	{
	  		trace("success");
	  	}
	}
}