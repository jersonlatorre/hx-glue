package glue.input;

import glue.input.Input;

/**
 * Simplified input actions API
 * Reduces verbosity for common input patterns
 */
@:final class InputActions
{
	public static function bind(actions:Map<String, Array<Int>>):Void
	{
		for (actionName => keys in actions)
		{
			Input.bindKeys(actionName, keys);
		}
	}

	public static function create():InputActionBuilder
	{
		return new InputActionBuilder();
	}

	public static function bindWASD():Void
	{
		Input.bindKeys("up", [87]); // W
		Input.bindKeys("down", [83]); // S
		Input.bindKeys("left", [65]); // A
		Input.bindKeys("right", [68]); // D
	}

	public static function bindArrows():Void
	{
		Input.bindKeys("up", [38]); // UP
		Input.bindKeys("down", [40]); // DOWN
		Input.bindKeys("left", [37]); // LEFT
		Input.bindKeys("right", [39]); // RIGHT
	}

	public static function bindWASDAndArrows():Void
	{
		Input.bindKeys("up", [87, 38]); // W, UP
		Input.bindKeys("down", [83, 40]); // S, DOWN
		Input.bindKeys("left", [65, 37]); // A, LEFT
		Input.bindKeys("right", [68, 39]); // D, RIGHT
	}

	public static function getDirection(left:String = "left", right:String = "right", up:String = "up", down:String = "down"):glue.math.Vector2D
	{
		var x:Float = 0;
		var y:Float = 0;

		if (Input.isKeyPressed(left)) x -= 1;
		if (Input.isKeyPressed(right)) x += 1;
		if (Input.isKeyPressed(up)) y -= 1;
		if (Input.isKeyPressed(down)) y += 1;

		return new glue.math.Vector2D(x, y);
	}

	public static function getHorizontal(left:String = "left", right:String = "right"):Float
	{
		var value:Float = 0;
		if (Input.isKeyPressed(left)) value -= 1;
		if (Input.isKeyPressed(right)) value += 1;
		return value;
	}

	public static function getVertical(up:String = "up", down:String = "down"):Float
	{
		var value:Float = 0;
		if (Input.isKeyPressed(up)) value -= 1;
		if (Input.isKeyPressed(down)) value += 1;
		return value;
	}
}

/**
 * Fluent API for building input bindings
 */
class InputActionBuilder
{
	final bindings:Map<String, Array<Int>> = new Map();

	public function new() {}

	public function action(name:String, keys:Array<Int>):InputActionBuilder
	{
		bindings.set(name, keys);
		return this;
	}

	public function apply():Void
	{
		InputActions.bind(bindings);
	}
}
