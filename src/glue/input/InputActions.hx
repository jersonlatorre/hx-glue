package glue.input;

import glue.input.GInput;

/**
 * Simplified input actions API
 * Reduces verbosity for common input patterns
 */
@:final class InputActions
{
	// Bind multiple actions at once
	public static function bind(actions:Map<String, Array<Int>>):Void
	{
		for (actionName => keys in actions)
		{
			GInput.bindKeys(actionName, keys);
		}
	}

	// Fluent API for binding
	public static function create():InputActionBuilder
	{
		return new InputActionBuilder();
	}

	// Common presets
	public static function bindWASD():Void
	{
		GInput.bindKeys("up", [87]); // W
		GInput.bindKeys("down", [83]); // S
		GInput.bindKeys("left", [65]); // A
		GInput.bindKeys("right", [68]); // D
	}

	public static function bindArrows():Void
	{
		GInput.bindKeys("up", [38]); // UP
		GInput.bindKeys("down", [40]); // DOWN
		GInput.bindKeys("left", [37]); // LEFT
		GInput.bindKeys("right", [39]); // RIGHT
	}

	public static function bindWASDAndArrows():Void
	{
		GInput.bindKeys("up", [87, 38]); // W, UP
		GInput.bindKeys("down", [83, 40]); // S, DOWN
		GInput.bindKeys("left", [65, 37]); // A, LEFT
		GInput.bindKeys("right", [68, 39]); // D, RIGHT
	}

	// Get directional input as vector
	public static function getDirection(left:String = "left", right:String = "right", up:String = "up", down:String = "down"):glue.math.GVector2D
	{
		var x:Float = 0;
		var y:Float = 0;

		if (GInput.isKeyPressed(left)) x -= 1;
		if (GInput.isKeyPressed(right)) x += 1;
		if (GInput.isKeyPressed(up)) y -= 1;
		if (GInput.isKeyPressed(down)) y += 1;

		return new glue.math.GVector2D(x, y);
	}

	// Get horizontal axis (-1, 0, 1)
	public static function getHorizontal(left:String = "left", right:String = "right"):Float
	{
		var value:Float = 0;
		if (GInput.isKeyPressed(left)) value -= 1;
		if (GInput.isKeyPressed(right)) value += 1;
		return value;
	}

	// Get vertical axis (-1, 0, 1)
	public static function getVertical(up:String = "up", down:String = "down"):Float
	{
		var value:Float = 0;
		if (GInput.isKeyPressed(up)) value -= 1;
		if (GInput.isKeyPressed(down)) value += 1;
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
