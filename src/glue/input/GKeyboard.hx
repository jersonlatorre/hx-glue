package glue.input;

import glue.Glue;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Jerson La Torre
 */

 enum GKeyState { NONE; UP; DOWN; JUST_PRESSED; }

@:final class GKeyboard 
{
	static var _actions:Map<String, Array<Int>> = new Map<String, Array<Int>>();
	static var _keys:Map<Int, GKeyState> = new Map<Int, GKeyState>();

	static public function init()
	{
		Glue.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Glue.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	static public function bind(actionName:String, keys:Array<Int>)
	{
		_actions.set(actionName, keys);
	}

	static public function isDown(actionName:String):Bool
	{
		if (!_actions.exists(actionName))
		{
			throw 'The action \'$actionName\' has not been binded.';
			return false;
		}

		for (key in _actions.get(actionName))
		{
			if (_keys.exists(key) &&
					(_keys.get(key) == GKeyState.DOWN) || (_keys.get(key) == GKeyState.JUST_PRESSED))
			{
				return true;
			}
		}

		return false;
	}

	static public function justPressed(actionName:String):Bool
	{
		if (!_actions.exists(actionName))
		{
			throw 'The action \'$actionName\' has not been binded.';
			return false;
		}

		for (key in _actions.get(actionName))
		{
			if (_keys.exists(key) &&
					_keys.get(key) == GKeyState.JUST_PRESSED)
			{
				return true;
			}
		}

		return false;
	}

	static public function isUp(actionName:String):Bool
	{
		if (!_actions.exists(actionName))
		{
			throw 'The action \'$actionName\' has not been binded.';
			return null;
		}

		for (key in _actions.get(actionName))
		{
			if (_keys.exists(key) &&
					_keys.get(key) == GKeyState.UP)
			{
				return true;
			}
		}

		return false;
	}

	static function onKeyDown(e:KeyboardEvent)
	{
		if (_keys.get(e.keyCode) != GKeyState.DOWN)
			_keys.set(e.keyCode, GKeyState.JUST_PRESSED);	
	}

	static function onKeyUp(e:KeyboardEvent)
	{
		_keys.set(e.keyCode, GKeyState.UP);
	}

	static public function update()
	{
		for (action in _actions)
		{
			for (key in action)
			{
				if (_keys.get(key) == GKeyState.UP)
				{
					_keys.set(key, GKeyState.NONE);
				}

				if (_keys.get(key) == GKeyState.JUST_PRESSED)
				{
					_keys.set(key, GKeyState.DOWN);
				}
			}
		}
	}
}