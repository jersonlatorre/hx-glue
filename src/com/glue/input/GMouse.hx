package com.glue.input;

import com.glue.GEngine;
import com.glue.utils.GVector2D;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
/**
 * ...
 * @author Jerson La Torre
 */	
 
class GMouse 
{
	// public
	static public var position:GVector2D;
	static public var isDown:Bool;
	static public var isUp:Bool;
	static public var isPressed:Bool;
	
	public function new() 
	{
		
	}
	
	static public function init():Void
	{
		GEngine.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		GEngine.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		position = new GVector2D(0, 0);
	}
	
	static function onMouseDown(e:MouseEvent):Void
	{
		isDown = true;
		isPressed = true;
	}
	
	static function onMouseUp(e:MouseEvent):Void 
	{
		isDown = false;
		isUp = true;
		isPressed = false;
	}
	
	static public function update():Void
	{
		position.x = GEngine.stage.mouseX;
		position.y = GEngine.stage.mouseY;
	}
	
	static public function clear():Void
	{
		isUp = false;
		isDown = false;
	}
}