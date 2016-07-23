package com.glue.utils;

import haxe.Timer;

/**
 * ...
 * @author wara
 */

@final class GTime 
{
	static public var dt:Float;
	static public var factor:Float;
	static public var timelapse:Float;
	static public var framerate:Float;
	
	static var _now:Float;
	static var _last:Float;
	static var _dtLast:Float;
	
	static public function init():Void 
	{
		timelapse = 0;
		factor = 0;
		framerate = GEngine.stage.frameRate;
		
		//_now = Timer.stamp() * 1000;
		
		#if html5
		_last = _now = js.Lib.eval("Date.now()");
		#elseif flash
		_last = _now = flash.Lib.getTimer();
		#elseif neko
		_last = _now = Timer.stamp() * 1000;
		#elseif cpp
		_last = _now = Sys.time() * 1000;
		#else
		_last = _now = Sys.time() * 1000;
		#end
		
		_dtLast = dt = 0;
	}
	
	static public function update():Void 
	{
		//_now = Timer.stamp() * 1000;
		
		#if html5
		_now = js.Lib.eval("Date.now()");
		#elseif flash
		_now = flash.Lib.getTimer();
		#elseif neko
		_now = Timer.stamp() * 1000;
		#elseif cpp
		_now = Sys.time() * 1000;
		#else
		_now = Sys.time() * 1000;
		#end
		
		dt = (_now - _last);
		
		if (dt == 0) dt = _dtLast;
		
		framerate = Std.int(1000 / dt);
		factor = dt * GEngine.stage.frameRate / 1000;
		
		_last = _now;
		_dtLast = dt;
		timelapse += dt;
	}
}