package com.glue.utils;

import haxe.Timer;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GTime 
{
	static public var deltaTime:Float;
	static public var factor:Float;
	static public var timelapse:Float;
	static public var framerate:Float;
	
	static var _now:Float;
	static var _last:Float;
	static var _dtLast:Float;
	
	static public function init():Void 
	{
		timelapse = 0;
		framerate = GEngine.stage.frameRate;
		
		_last = _now = Timer.stamp() * 1000;
		_dtLast = deltaTime = 0;
	}
	
	static public function update():Void 
	{
		_now = Timer.stamp() * 1000;
		deltaTime = (_now - _last);
		
		if (deltaTime == 0) deltaTime = _dtLast;
		
		framerate = Std.int(1000 / deltaTime);
		
		_last = _now;
		_dtLast = deltaTime;
		timelapse += deltaTime;
	}
}