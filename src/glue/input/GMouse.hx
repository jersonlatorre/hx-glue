package glue.input;

import glue.Glue;
import glue.utils.GVector2D;
import openfl.events.MouseEvent;
/**
 * ...
 * @author Jerson La Torre
 */	
 
@final class GMouse 
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
		Glue.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Glue.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
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
		position.x = Glue.stage.mouseX;
		position.y = Glue.stage.mouseY;
	}
	
	static public function clear():Void
	{
		isUp = false;
		isDown = false;
	}
}