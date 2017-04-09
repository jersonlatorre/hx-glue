package glue.utils;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GTools
{
	public static function floatToStringPrecision(n:Float, prec:Int)
	{
		n = Math.round(n * Math.pow(10, prec));
		
		var str = "" + n;
		var len = str.length;
		
		if (len <= prec)
		{
			while (len < prec)
			{
				str = "0" + str;
				len++;
			}
			
			return "0." + str;
		}
		else
		{
			return str.substr(0, str.length - prec) + '.' + str.substr(str.length - prec);
		}
	}

	public static function getClassName(object:Any):String
	{
		if (object == null) return null;
		var a:Array<String> = cast(Type.getClassName(Type.getClass(object)), String).split(".");
		var className:String = a[a.length - 1];
		return className;
	}
}