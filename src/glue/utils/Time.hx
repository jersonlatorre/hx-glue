package glue.utils;

import haxe.Timer;

/**
 * ...
 * @author Jerson La Torre
 */

@:final class Time 
{
	static public var deltaTime:Float;
	static public var timelapse:Float;
	static public var framerate:Float;
	
	static var _now:Float;
	static var _last:Float;
	static var _dtLast:Float;
	
	static public function init()
	{
		deltaTime = 0;
		timelapse = 0;
		framerate = Glue.stage.frameRate;
		_now = _last = Timer.stamp();
	}
	
	static public function update()
	{
		_now = Timer.stamp();
		deltaTime = _now - _last;

		timelapse += deltaTime;
		
		framerate = Std.int(1 / deltaTime);
		_last = _now;
	}
}