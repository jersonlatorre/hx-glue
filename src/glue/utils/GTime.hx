package glue.utils;

import openfl.Lib;
import haxe.Timer;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GTime 
{
	static public var deltaTime:Float;
	static public var timelapse:Float;
	static public var framerate:Float;
	
	static var _now:Float;
	static var _last:Float;
	static var _dtLast:Float;
	
	static public function init():Void 
	{
		deltaTime = 0;
		_now = _last = Timer.stamp();
		
	}
	
	static public function update():Void 
	{
		_now = Timer.stamp();
		deltaTime = _now - _last;
		
		// if (deltaTime == 0) deltaTime = _dtLast;
		
		// framerate = Std.int(1 / deltaTime);
		// trace(1 / deltaTime);
		_last = _now;
		// _dtLast = deltaTime;
		// timelapse += deltaTime;
	}
}