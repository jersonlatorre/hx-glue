package glue.testing;

import glue.core.IInputService;
import glue.math.Vector2D;

/**
 * Mock input service for testing.
 * Allows simulating input without actual keyboard/mouse.
 *
 * Usage:
 *   var mock = new MockInputService();
 *   mock.pressKey("jump");
 *   Services.input = mock;
 *
 *   // Now any code using Services.input.isKeyPressed("jump") returns true
 */
class MockInputService implements IInputService
{
	var pressedKeys:Map<String, Bool> = new Map();
	var downKeys:Map<String, Bool> = new Map();
	var upKeys:Map<String, Bool> = new Map();

	public var mousePosition:Vector2D = new Vector2D(0, 0);

	public function new() {}

	public function pressKey(action:String):Void
	{
		pressedKeys.set(action, true);
	}

	public function releaseKey(action:String):Void
	{
		pressedKeys.remove(action);
		downKeys.remove(action);
		upKeys.set(action, true);
	}

	public function holdKey(action:String):Void
	{
		downKeys.set(action, true);
		pressedKeys.set(action, true);
	}

	public function setMousePosition(x:Float, y:Float):Void
	{
		mousePosition.set(x, y);
	}

	public function reset():Void
	{
		pressedKeys.clear();
		downKeys.clear();
		upKeys.clear();
		mousePosition.set(0, 0);
	}

	public function isKeyPressed(action:String):Bool
	{
		return pressedKeys.exists(action);
	}

	public function isKeyDown(action:String):Bool
	{
		return downKeys.exists(action);
	}

	public function isKeyUp(action:String):Bool
	{
		return upKeys.exists(action);
	}

	public function getMousePosition():Vector2D
	{
		return mousePosition;
	}

	/**
	 * Call at end of frame to clear up states (like real input does)
	 */
	public function clearFrame():Void
	{
		upKeys.clear();
		for (key in downKeys.keys())
		{
			pressedKeys.set(key, true);
		}
		downKeys.clear();
	}
}
