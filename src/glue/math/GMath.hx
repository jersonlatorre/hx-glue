package glue.math;

/**
 * ...
 * @author Jerson La Torre
 */

@:final class GMath 
{
	static public function sign(x:Float):Int
	{
		var sign = 0;
		if (x > 0) return sign = 1;
		if (x < 0) return sign = -1;
		return sign;
	}
	
	static public function sin(x:Float):Float
	{
		return Math.sin(x);
	}
	
	static public function cos(x:Float):Float
	{
		return Math.cos(x);
	}
}
