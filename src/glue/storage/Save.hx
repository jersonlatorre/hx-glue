package glue.storage;

import haxe.Json;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.net.SharedObject;

/**
 * Simple save/load system using SharedObject (localStorage on web).
 *
 * Usage:
 *   // Simple key-value
 *   Save.set("highscore", 1000);
 *   var score = Save.get("highscore", 0);
 *
 *   // Save object
 *   Save.setObject("player", { name: "Hero", level: 5 });
 *   var player = Save.getObject("player");
 *
 *   // Slots
 *   Save.slot(1).set("progress", 50);
 *   Save.slot(2).set("progress", 75);
 */
class Save
{
	static var _sharedObject:SharedObject;
	static var _currentSlot:Int = 0;
	static var _slotPrefix:String = "";

	static function init():Void
	{
		if (_sharedObject == null)
		{
			_sharedObject = SharedObject.getLocal("glue_save");
		}
	}

	/**
	 * Select a save slot (0 = default)
	 */
	public static function slot(index:Int):Save
	{
		_currentSlot = index;
		_slotPrefix = index > 0 ? 'slot${index}_' : "";
		return null; // Returns null but allows chaining via static methods
	}

	/**
	 * Set a value
	 */
	public static function set(key:String, value:Dynamic):Void
	{
		init();
		var fullKey = _slotPrefix + key;
		Reflect.setField(_sharedObject.data, fullKey, value);
		_sharedObject.flush();
	}

	/**
	 * Get a value with default
	 */
	public static function get(key:String, ?defaultValue:Dynamic):Dynamic
	{
		init();
		var fullKey = _slotPrefix + key;
		var value = Reflect.field(_sharedObject.data, fullKey);
		return value != null ? value : defaultValue;
	}

	/**
	 * Get an integer
	 */
	public static function getInt(key:String, defaultValue:Int = 0):Int
	{
		var value = get(key);
		if (value == null) return defaultValue;
		if (Std.isOfType(value, Int)) return value;
		if (Std.isOfType(value, Float)) return Std.int(value);
		if (Std.isOfType(value, String)) return Std.parseInt(value);
		return defaultValue;
	}

	/**
	 * Get a float
	 */
	public static function getFloat(key:String, defaultValue:Float = 0):Float
	{
		var value = get(key);
		if (value == null) return defaultValue;
		if (Std.isOfType(value, Float)) return value;
		if (Std.isOfType(value, Int)) return value;
		if (Std.isOfType(value, String)) return Std.parseFloat(value);
		return defaultValue;
	}

	/**
	 * Get a string
	 */
	public static function getString(key:String, defaultValue:String = ""):String
	{
		var value = get(key);
		if (value == null) return defaultValue;
		if (Std.isOfType(value, String)) return value;
		return Std.string(value);
	}

	/**
	 * Get a bool
	 */
	public static function getBool(key:String, defaultValue:Bool = false):Bool
	{
		var value = get(key);
		if (value == null) return defaultValue;
		if (Std.isOfType(value, Bool)) return value;
		return defaultValue;
	}

	/**
	 * Save an object (serialized)
	 */
	public static function setObject(key:String, obj:Dynamic):Void
	{
		init();
		var fullKey = _slotPrefix + key;
		var serialized = Json.stringify(obj);
		Reflect.setField(_sharedObject.data, fullKey, serialized);
		_sharedObject.flush();
	}

	/**
	 * Load an object
	 */
	public static function getObject(key:String):Dynamic
	{
		init();
		var fullKey = _slotPrefix + key;
		var serialized = Reflect.field(_sharedObject.data, fullKey);
		if (serialized == null) return null;
		try
		{
			return Json.parse(serialized);
		}
		catch (e:Dynamic)
		{
			return null;
		}
	}

	/**
	 * Check if a key exists
	 */
	public static function exists(key:String):Bool
	{
		init();
		var fullKey = _slotPrefix + key;
		return Reflect.hasField(_sharedObject.data, fullKey);
	}

	/**
	 * Delete a key
	 */
	public static function delete(key:String):Void
	{
		init();
		var fullKey = _slotPrefix + key;
		Reflect.deleteField(_sharedObject.data, fullKey);
		_sharedObject.flush();
	}

	/**
	 * Clear current slot
	 */
	public static function clear():Void
	{
		init();
		if (_slotPrefix == "")
		{
			// Clear everything
			_sharedObject.clear();
		}
		else
		{
			// Clear only current slot
			var fields = Reflect.fields(_sharedObject.data);
			for (field in fields)
			{
				if (StringTools.startsWith(field, _slotPrefix))
				{
					Reflect.deleteField(_sharedObject.data, field);
				}
			}
			_sharedObject.flush();
		}
	}

	/**
	 * Clear all save data
	 */
	public static function clearAll():Void
	{
		init();
		_sharedObject.clear();
	}

	/**
	 * Get all keys in current slot
	 */
	public static function keys():Array<String>
	{
		init();
		var result:Array<String> = [];
		var fields = Reflect.fields(_sharedObject.data);

		for (field in fields)
		{
			if (_slotPrefix == "" || StringTools.startsWith(field, _slotPrefix))
			{
				var key = _slotPrefix == "" ? field : field.substr(_slotPrefix.length);
				result.push(key);
			}
		}

		return result;
	}

	/**
	 * Increment a numeric value
	 */
	public static function increment(key:String, amount:Int = 1):Int
	{
		var current = getInt(key, 0);
		var newValue = current + amount;
		set(key, newValue);
		return newValue;
	}

	/**
	 * Update highscore (only saves if higher)
	 */
	public static function highscore(key:String, score:Int):Bool
	{
		var current = getInt(key, 0);
		if (score > current)
		{
			set(key, score);
			return true;
		}
		return false;
	}

	/**
	 * Check if this is first run
	 */
	public static function isFirstRun():Bool
	{
		if (!exists("_firstRun"))
		{
			set("_firstRun", false);
			return true;
		}
		return false;
	}

	/**
	 * Get play count (auto-increments)
	 */
	public static function playCount():Int
	{
		return increment("_playCount", 1);
	}
}
