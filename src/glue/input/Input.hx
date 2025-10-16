package glue.input;

import glue.Glue;
import glue.math.Vector2D;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;

/**
 * ...
 * @author Jerson La Torre
 */

enum KeyState { NONE; UP; PRESSED; DOWN; }

@:final class Input
{
	static var _actions:Map<String, Array<Int>> = new Map<String, Array<Int>>();
	static var _keys:Map<Int, KeyState> = new Map<Int, KeyState>();

	static public var mousePosition:Vector2D = new Vector2D(0, 0);
	static public var isMouseDown:Bool;
	static public var isMouseUp:Bool;
	static public var isMousePressed:Bool;

	static public function init()
	{
		Glue.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Glue.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		Glue.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Glue.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	static function onMouseDown(e:MouseEvent)
	{
		isMouseDown = true;
		isMousePressed = true;
	}
	
	static function onMouseUp(e:MouseEvent) 
	{
		isMouseDown = false;
		isMouseUp = true;
		isMousePressed = false;
	}

	static public function bindKeys(actionName:String, keys:Array<Int>)
	{
		_actions.set(actionName, keys);
	}

	static public function isKeyPressed(actionName:String):Bool
	{
		if (!_actions.exists(actionName))
		{
			throw 'The action \'$actionName\' has not been binded.';
		}

		for (key in _actions.get(actionName))
		{
			if (_keys.exists(key) &&
					(_keys.get(key) == KeyState.PRESSED) || (_keys.get(key) == KeyState.DOWN))
			{
				return true;
			}
		}

		return false;
	}

	static public function isKeyDown(actionName:String):Bool
	{
		if (!_actions.exists(actionName))
		{
			throw 'The action \'$actionName\' has not been binded.';
		}

		for (key in _actions.get(actionName))
		{
			if (_keys.exists(key) &&
					_keys.get(key) == KeyState.DOWN)
			{
				return true;
			}
		}

		return false;
	}

	static public function isKeyUp(actionName:String):Bool
	{
		if (!_actions.exists(actionName))
		{
			throw 'The action \'$actionName\' has not been binded.';
		}

		for (key in _actions.get(actionName))
		{
			if (_keys.exists(key) &&
					_keys.get(key) == KeyState.UP)
			{
				return true;
			}
		}

		return false;
	}

	static function onKeyDown(e:KeyboardEvent)
	{
		if (_keys.get(e.keyCode) != KeyState.PRESSED)
			_keys.set(e.keyCode, KeyState.DOWN);	
	}

	static function onKeyUp(e:KeyboardEvent)
	{
		_keys.set(e.keyCode, KeyState.UP);
	}

	static public function hideMouse()
	{
		Mouse.hide();
	}

	static public function showMouse()
	{
		Mouse.show();
	}

	@:allow(glue.Glue)
	static function update()
	{
		mousePosition.x = Glue.stage.mouseX;
		mousePosition.y = Glue.stage.mouseY;
	}

	@:allow(glue.Glue)
	static function clear()
	{
		isMouseUp = false;
		isMouseDown = false;

		for (action in _actions)
		{
			for (key in action)
			{
				if (_keys.get(key) == KeyState.UP)
				{
					_keys.set(key, KeyState.NONE);
				}

				if (_keys.get(key) == KeyState.DOWN)
				{
					_keys.set(key, KeyState.PRESSED);
				}
			}
		}
	}
}
