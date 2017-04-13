package glue.input;

import glue.Glue;
import glue.math.GVector2D;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
/**
 * ...
 * @author Jerson La Torre
 */	
 
@final class GMouse 
{
	// public
	static public var position:GVector2D = new GVector2D(0, 0);
	static public var isDown:Bool;
	static public var isUp:Bool;
	static public var isPressed:Bool;
	
	public function new() 
	{
		
	}
	
	static public function init()
	{
		Glue.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Glue.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	static function onMouseDown(e:MouseEvent)
	{
		isDown = true;
		isPressed = true;
	}
	
	static function onMouseUp(e:MouseEvent) 
	{
		isDown = false;
		isUp = true;
		isPressed = false;
	}
	
	static public function update()
	{
		position.x = Glue.stage.mouseX;
		position.y = Glue.stage.mouseY;
	}

	static public function hide()
	{
		Mouse.hide();
	}

	static public function show()
	{
		Mouse.show();
	}
	
	static public function clear()
	{
		isUp = false;
		isDown = false;
	}
}