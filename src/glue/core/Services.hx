package glue.core;

import glue.input.Input;
import glue.math.Vector2D;
import glue.utils.Time;

/**
 * Service locator for framework services.
 * Allows dependency injection for testing or custom implementations.
 *
 * Default behavior uses the static singletons (Input, Time, etc).
 * For testing, you can inject mock implementations:
 *
 *   // In test setup:
 *   Services.input = new MockInputService();
 *   Services.time = new MockTimeService();
 *
 *   // In test teardown:
 *   Services.reset();
 */
class Services
{
	static var _input:IInputService;
	static var _time:ITimeService;

	/**
	 * Get the input service (defaults to static Input singleton wrapper)
	 */
	public static var input(get, set):IInputService;

	static function get_input():IInputService
	{
		if (_input == null)
		{
			_input = new DefaultInputService();
		}
		return _input;
	}

	static function set_input(service:IInputService):IInputService
	{
		_input = service;
		return _input;
	}

	/**
	 * Get the time service (defaults to static Time singleton wrapper)
	 */
	public static var time(get, set):ITimeService;

	static function get_time():ITimeService
	{
		if (_time == null)
		{
			_time = new DefaultTimeService();
		}
		return _time;
	}

	static function set_time(service:ITimeService):ITimeService
	{
		_time = service;
		return _time;
	}

	/**
	 * Reset all services to defaults
	 */
	public static function reset():Void
	{
		_input = null;
		_time = null;
	}
}

/**
 * Default input service wrapping the static Input class
 */
private class DefaultInputService implements IInputService
{
	public function new() {}

	public function isKeyPressed(action:String):Bool
	{
		return Input.isKeyPressed(action);
	}

	public function isKeyDown(action:String):Bool
	{
		return Input.isKeyDown(action);
	}

	public function isKeyUp(action:String):Bool
	{
		return Input.isKeyUp(action);
	}

	public function getMousePosition():Vector2D
	{
		return Input.mousePosition;
	}
}

/**
 * Default time service wrapping the static Time class
 */
private class DefaultTimeService implements ITimeService
{
	public function new() {}

	public var deltaTime(get, never):Float;

	function get_deltaTime():Float
	{
		return Time.deltaTime;
	}

	public var elapsed(get, never):Float;

	function get_elapsed():Float
	{
		return Time.elapsed;
	}

	public var scale(get, set):Float;

	function get_scale():Float
	{
		return Time.scale;
	}

	function set_scale(value:Float):Float
	{
		Time.scale = value;
		return value;
	}
}
