package glue.input;

import glue.math.Vector2D;
import openfl.ui.GameInput;
import openfl.ui.GameInputControl;
import openfl.ui.GameInputDevice;
import openfl.events.GameInputEvent;

/**
 * Gamepad input handling.
 * Supports multiple controllers with button and axis mapping.
 *
 * Usage:
 *   // In your scene init:
 *   Gamepad.bindButton("jump", GamepadButton.A);
 *   Gamepad.bindButton("attack", GamepadButton.X);
 *   Gamepad.bindAxis("move", GamepadAxis.LEFT_STICK);
 *
 *   // In your entity update:
 *   if (Gamepad.isPressed("jump")) { ... }
 *   var move = Gamepad.getAxis("move"); // Vector2D
 */
@:final class Gamepad
{
	static var _gameInput:GameInput;
	static var _devices:Array<GameInputDevice> = [];
	static var _buttonBindings:Map<String, GamepadButton> = new Map();
	static var _axisBindings:Map<String, GamepadAxis> = new Map();

	static var _buttonStates:Map<Int, Map<GamepadButton, ButtonState>> = new Map();
	static var _axisValues:Map<Int, Map<GamepadAxis, Vector2D>> = new Map();

	static var _deadzone:Float = 0.15;

	public static var isSupported(get, never):Bool;
	public static var deviceCount(get, never):Int;
	public static var deadzone(get, set):Float;

	static function get_isSupported():Bool
	{
		return GameInput.isSupported;
	}

	static function get_deviceCount():Int
	{
		return _devices.length;
	}

	static function get_deadzone():Float
	{
		return _deadzone;
	}

	static function set_deadzone(value:Float):Float
	{
		_deadzone = value;
		return _deadzone;
	}

	@:allow(glue.Glue)
	static function init():Void
	{
		if (!GameInput.isSupported) return;

		_gameInput = new GameInput();
		_gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, onDeviceAdded);
		_gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, onDeviceRemoved);

		// Check for already connected devices
		for (i in 0...GameInput.numDevices)
		{
			var device = GameInput.getDeviceAt(i);
			if (device != null)
			{
				registerDevice(device);
			}
		}
	}

	static function onDeviceAdded(event:GameInputEvent):Void
	{
		if (event.device != null)
		{
			registerDevice(event.device);
		}
	}

	static function onDeviceRemoved(event:GameInputEvent):Void
	{
		if (event.device != null)
		{
			unregisterDevice(event.device);
		}
	}

	static function registerDevice(device:GameInputDevice):Void
	{
		if (_devices.indexOf(device) == -1)
		{
			_devices.push(device);
			device.enabled = true;

			var deviceIndex = _devices.indexOf(device);
			_buttonStates.set(deviceIndex, new Map());
			_axisValues.set(deviceIndex, new Map());

			// Initialize axis values
			var axes = _axisValues.get(deviceIndex);
			axes.set(GamepadAxis.LEFT_STICK, new Vector2D(0, 0));
			axes.set(GamepadAxis.RIGHT_STICK, new Vector2D(0, 0));
			axes.set(GamepadAxis.TRIGGERS, new Vector2D(0, 0));
		}
	}

	static function unregisterDevice(device:GameInputDevice):Void
	{
		var index = _devices.indexOf(device);
		if (index != -1)
		{
			_devices.splice(index, 1);
			_buttonStates.remove(index);
			_axisValues.remove(index);
		}
	}

	/**
	 * Bind an action name to a gamepad button
	 */
	public static function bindButton(action:String, button:GamepadButton):Void
	{
		_buttonBindings.set(action, button);
	}

	/**
	 * Bind an action name to a gamepad axis
	 */
	public static function bindAxis(action:String, axis:GamepadAxis):Void
	{
		_axisBindings.set(action, axis);
	}

	/**
	 * Check if a button action is currently pressed (any controller)
	 */
	public static function isPressed(action:String, ?deviceIndex:Int = -1):Bool
	{
		var button = _buttonBindings.get(action);
		if (button == null) return false;

		if (deviceIndex >= 0)
		{
			return isButtonPressed(deviceIndex, button);
		}

		// Check all devices
		for (i in 0..._devices.length)
		{
			if (isButtonPressed(i, button)) return true;
		}
		return false;
	}

	/**
	 * Check if a button action was just pressed this frame
	 */
	public static function isDown(action:String, ?deviceIndex:Int = -1):Bool
	{
		var button = _buttonBindings.get(action);
		if (button == null) return false;

		if (deviceIndex >= 0)
		{
			return isButtonDown(deviceIndex, button);
		}

		for (i in 0..._devices.length)
		{
			if (isButtonDown(i, button)) return true;
		}
		return false;
	}

	/**
	 * Check if a button action was just released this frame
	 */
	public static function isUp(action:String, ?deviceIndex:Int = -1):Bool
	{
		var button = _buttonBindings.get(action);
		if (button == null) return false;

		if (deviceIndex >= 0)
		{
			return isButtonUp(deviceIndex, button);
		}

		for (i in 0..._devices.length)
		{
			if (isButtonUp(i, button)) return true;
		}
		return false;
	}

	/**
	 * Get axis value as Vector2D (e.g., left stick, right stick)
	 */
	public static function getAxis(action:String, ?deviceIndex:Int = 0):Vector2D
	{
		var axis = _axisBindings.get(action);
		if (axis == null) return new Vector2D(0, 0);

		var axes = _axisValues.get(deviceIndex);
		if (axes == null) return new Vector2D(0, 0);

		var value = axes.get(axis);
		return value != null ? value : new Vector2D(0, 0);
	}

	/**
	 * Get raw axis value by axis enum
	 */
	public static function getAxisRaw(axis:GamepadAxis, ?deviceIndex:Int = 0):Vector2D
	{
		var axes = _axisValues.get(deviceIndex);
		if (axes == null) return new Vector2D(0, 0);

		var value = axes.get(axis);
		return value != null ? value : new Vector2D(0, 0);
	}

	/**
	 * Check raw button state
	 */
	public static function isButtonPressed(deviceIndex:Int, button:GamepadButton):Bool
	{
		var states = _buttonStates.get(deviceIndex);
		if (states == null) return false;

		var state = states.get(button);
		return state == ButtonState.PRESSED || state == ButtonState.DOWN;
	}

	static function isButtonDown(deviceIndex:Int, button:GamepadButton):Bool
	{
		var states = _buttonStates.get(deviceIndex);
		if (states == null) return false;

		return states.get(button) == ButtonState.DOWN;
	}

	static function isButtonUp(deviceIndex:Int, button:GamepadButton):Bool
	{
		var states = _buttonStates.get(deviceIndex);
		if (states == null) return false;

		return states.get(button) == ButtonState.UP;
	}

	@:allow(glue.Glue)
	static function update():Void
	{
		for (i in 0..._devices.length)
		{
			var device = _devices[i];
			if (device == null || !device.enabled) continue;

			updateDeviceControls(i, device);
		}
	}

	static function updateDeviceControls(deviceIndex:Int, device:GameInputDevice):Void
	{
		var states = _buttonStates.get(deviceIndex);
		var axes = _axisValues.get(deviceIndex);

		if (states == null || axes == null) return;

		for (j in 0...device.numControls)
		{
			var control = device.getControlAt(j);
			if (control == null) continue;

			var id = control.id.toLowerCase();
			var value = control.value;

			// Map control IDs to buttons/axes
			// Standard mapping for most controllers
			if (id.indexOf("button") != -1 || id.indexOf("btn") != -1)
			{
				var button = mapControlToButton(id, Std.int(j));
				if (button != null)
				{
					updateButtonState(states, button, value > 0.5);
				}
			}
			else if (id.indexOf("axis") != -1 || id.indexOf("stick") != -1 || id.indexOf("trigger") != -1)
			{
				updateAxisValue(axes, id, value, j);
			}
		}
	}

	static function mapControlToButton(id:String, index:Int):Null<GamepadButton>
	{
		// Standard gamepad button mapping
		if (id.indexOf("0") != -1 || id.indexOf("a") != -1) return GamepadButton.A;
		if (id.indexOf("1") != -1 || id.indexOf("b") != -1) return GamepadButton.B;
		if (id.indexOf("2") != -1 || id.indexOf("x") != -1) return GamepadButton.X;
		if (id.indexOf("3") != -1 || id.indexOf("y") != -1) return GamepadButton.Y;
		if (id.indexOf("4") != -1 || id.indexOf("lb") != -1 || id.indexOf("l1") != -1) return GamepadButton.LB;
		if (id.indexOf("5") != -1 || id.indexOf("rb") != -1 || id.indexOf("r1") != -1) return GamepadButton.RB;
		if (id.indexOf("6") != -1 || id.indexOf("lt") != -1 || id.indexOf("l2") != -1) return GamepadButton.LT;
		if (id.indexOf("7") != -1 || id.indexOf("rt") != -1 || id.indexOf("r2") != -1) return GamepadButton.RT;
		if (id.indexOf("8") != -1 || id.indexOf("back") != -1 || id.indexOf("select") != -1) return GamepadButton.BACK;
		if (id.indexOf("9") != -1 || id.indexOf("start") != -1) return GamepadButton.START;
		if (id.indexOf("10") != -1 || id.indexOf("l3") != -1) return GamepadButton.L3;
		if (id.indexOf("11") != -1 || id.indexOf("r3") != -1) return GamepadButton.R3;
		if (id.indexOf("12") != -1 || id.indexOf("up") != -1) return GamepadButton.DPAD_UP;
		if (id.indexOf("13") != -1 || id.indexOf("down") != -1) return GamepadButton.DPAD_DOWN;
		if (id.indexOf("14") != -1 || id.indexOf("left") != -1) return GamepadButton.DPAD_LEFT;
		if (id.indexOf("15") != -1 || id.indexOf("right") != -1) return GamepadButton.DPAD_RIGHT;
		return null;
	}

	static function updateAxisValue(axes:Map<GamepadAxis, Vector2D>, id:String, value:Float, index:Int):Void
	{
		// Apply deadzone
		if (Math.abs(value) < _deadzone) value = 0;

		var leftStick = axes.get(GamepadAxis.LEFT_STICK);
		var rightStick = axes.get(GamepadAxis.RIGHT_STICK);
		var triggers = axes.get(GamepadAxis.TRIGGERS);

		if (leftStick == null) leftStick = new Vector2D(0, 0);
		if (rightStick == null) rightStick = new Vector2D(0, 0);
		if (triggers == null) triggers = new Vector2D(0, 0);

		// Map based on control ID or index
		if (id.indexOf("leftx") != -1 || id.indexOf("lx") != -1 || index == 0)
		{
			leftStick.x = value;
		}
		else if (id.indexOf("lefty") != -1 || id.indexOf("ly") != -1 || index == 1)
		{
			leftStick.y = value;
		}
		else if (id.indexOf("rightx") != -1 || id.indexOf("rx") != -1 || index == 2)
		{
			rightStick.x = value;
		}
		else if (id.indexOf("righty") != -1 || id.indexOf("ry") != -1 || index == 3)
		{
			rightStick.y = value;
		}
		else if (id.indexOf("lefttrigger") != -1 || id.indexOf("lt") != -1 || index == 4)
		{
			triggers.x = value;
		}
		else if (id.indexOf("righttrigger") != -1 || id.indexOf("rt") != -1 || index == 5)
		{
			triggers.y = value;
		}

		axes.set(GamepadAxis.LEFT_STICK, leftStick);
		axes.set(GamepadAxis.RIGHT_STICK, rightStick);
		axes.set(GamepadAxis.TRIGGERS, triggers);
	}

	static function updateButtonState(states:Map<GamepadButton, ButtonState>, button:GamepadButton, pressed:Bool):Void
	{
		var current = states.get(button);

		if (pressed)
		{
			if (current == null || current == ButtonState.NONE || current == ButtonState.UP)
			{
				states.set(button, ButtonState.DOWN);
			}
			else
			{
				states.set(button, ButtonState.PRESSED);
			}
		}
		else
		{
			if (current == ButtonState.PRESSED || current == ButtonState.DOWN)
			{
				states.set(button, ButtonState.UP);
			}
			else
			{
				states.set(button, ButtonState.NONE);
			}
		}
	}

	@:allow(glue.Glue)
	static function clear():Void
	{
		for (deviceIndex in _buttonStates.keys())
		{
			var states = _buttonStates.get(deviceIndex);
			if (states == null) continue;

			for (button in states.keys())
			{
				var state = states.get(button);
				if (state == ButtonState.DOWN)
				{
					states.set(button, ButtonState.PRESSED);
				}
				else if (state == ButtonState.UP)
				{
					states.set(button, ButtonState.NONE);
				}
			}
		}
	}
}

/**
 * Standard gamepad buttons
 */
enum GamepadButton
{
	A;
	B;
	X;
	Y;
	LB;
	RB;
	LT;
	RT;
	BACK;
	START;
	L3;
	R3;
	DPAD_UP;
	DPAD_DOWN;
	DPAD_LEFT;
	DPAD_RIGHT;
}

/**
 * Gamepad axes
 */
enum GamepadAxis
{
	LEFT_STICK;
	RIGHT_STICK;
	TRIGGERS;
}

private enum ButtonState
{
	NONE;
	DOWN;
	PRESSED;
	UP;
}
