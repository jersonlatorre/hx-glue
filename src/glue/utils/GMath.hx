package glue.utils;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GMath 
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
		var sin:Float;
		
		//always wrap input angle to -PI..PI
		if (x < -3.14159265)
		{
			x += 6.28318531;
		}
		else
		{
			if (x >  3.14159265)
			{
				x -= 6.28318531;
			}
		}
		
		//compute sine
		if (x < 0)
		{
			sin = 1.27323954 * x + .405284735 * x * x;
		}
		
		else
		{
			sin = 1.27323954 * x - 0.405284735 * x * x;
		}
		
		return sin;
	}
	
	static public function cos(x:Float):Float
	{
		var cos:Float;
		
		//compute cosine: sin(x + PI/2) = cos(x)
		x += 1.57079632;
		
		if (x >  3.14159265)
		{
			x -= 6.28318531;
		}
		
		if (x < 0)
		{
			cos = 1.27323954 * x + 0.405284735 * x * x;
		}
		else
		{
			cos = 1.27323954 * x - 0.405284735 * x * x;
		}
		
		return cos;
	}
}