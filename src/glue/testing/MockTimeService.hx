package glue.testing;

import glue.core.ITimeService;

/**
 * Mock time service for testing.
 * Allows controlling time progression in tests.
 *
 * Usage:
 *   var mock = new MockTimeService();
 *   Services.time = mock;
 *
 *   mock.advance(0.016); // Simulate one frame at 60fps
 *   mock.advance(1.0);   // Simulate one second
 */
class MockTimeService implements ITimeService
{
	public var deltaTime(get, never):Float;
	public var elapsed(get, never):Float;
	public var scale(get, set):Float;

	var _deltaTime:Float = 0;
	var _elapsed:Float = 0;
	var _scale:Float = 1.0;

	public function new() {}

	function get_deltaTime():Float
	{
		return _deltaTime * _scale;
	}

	function get_elapsed():Float
	{
		return _elapsed;
	}

	function get_scale():Float
	{
		return _scale;
	}

	function set_scale(value:Float):Float
	{
		_scale = value;
		return _scale;
	}

	/**
	 * Advance time by the given amount
	 */
	public function advance(dt:Float):Void
	{
		_deltaTime = dt;
		_elapsed += dt * _scale;
	}

	/**
	 * Set delta time for the current frame
	 */
	public function setDeltaTime(dt:Float):Void
	{
		_deltaTime = dt;
	}

	/**
	 * Reset time to zero
	 */
	public function reset():Void
	{
		_deltaTime = 0;
		_elapsed = 0;
		_scale = 1.0;
	}
}
