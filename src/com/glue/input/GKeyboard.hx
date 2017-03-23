package com.glue.input;

import com.glue.Glue;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GKeyboard 
{
	static public inline var LEFT:Int = 37;
	static public inline var RIGHT:Int = 39;
	static public inline var UP:Int = 38;
	static public inline var DOWN:Int = 40;
	static public inline var SPACE:Int = 32;
	static public inline var PAUSE:Int = 80;
	
	static public var isLeft:Bool = false;
	static public var isRight:Bool = false;
	static public var isUp:Bool = false;
	static public var isDown:Bool = false;
	static public var isSpace:Bool = false;
	static public var isPause:Bool = false;
	
	public function new() 
	{
		
	}
	
	static public function pressed(name:Dynamic)
	{
		if (Std.is(name, String))
		{
			
		}
		
		if (Std.is(name, Int))
		{
			
		}
	}
	
	static public function init():Void
	{
		Glue.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Glue.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
	}
	
	static function onKeyDown(e:KeyboardEvent):Void 
	{
		switch (e.keyCode)
		{
			case LEFT, Keyboard.A: isLeft = true;
			case RIGHT, Keyboard.D: isRight = true;
			case UP, Keyboard.W: isUp = true;
			case DOWN, Keyboard.S: isDown = true;
			case SPACE: isSpace = true;
			case PAUSE: isPause = true;
		}
	}
	
	static function onKeyUp(e:KeyboardEvent):Void 
	{
		switch (e.keyCode)
		{
			case LEFT, Keyboard.A: isLeft = false;
			case RIGHT, Keyboard.D: isRight = false;
			case UP, Keyboard.W: isUp = false;
			case DOWN, Keyboard.S: isDown = false;
			case SPACE: isSpace = false;
			case PAUSE: isPause = false;
		}
	}
}