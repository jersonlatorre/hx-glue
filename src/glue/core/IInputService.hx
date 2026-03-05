package glue.core;

import glue.math.Vector2D;

/**
 * Interface for input services.
 * Allows mocking input for testing or custom input implementations.
 */
interface IInputService
{
	function isKeyPressed(action:String):Bool;
	function isKeyDown(action:String):Bool;
	function isKeyUp(action:String):Bool;
	function getMousePosition():Vector2D;
}
