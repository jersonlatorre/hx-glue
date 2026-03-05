package glue.debug;

import glue.Glue;
import glue.style.Palette;
import glue.utils.Time;
import openfl.display.Sprite;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * Debug overlay with performance info and tools.
 *
 * Usage:
 *   Debug.show();
 *   Debug.hide();
 *   Debug.toggle();
 *
 *   // Log to overlay
 *   Debug.log("Player spawned");
 *   Debug.watch("health", player.health);
 *
 *   // Draw debug shapes
 *   Debug.point(x, y);
 *   Debug.line(x1, y1, x2, y2);
 *   Debug.rect(x, y, w, h);
 */
class Debug
{
	static var _overlay:Sprite;
	static var _statsText:TextField;
	static var _logText:TextField;
	static var _watchText:TextField;
	static var _drawLayer:Sprite;

	static var _visible:Bool = false;
	static var _logs:Array<String> = [];
	static var _watches:Map<String, Dynamic> = new Map();
	static var _maxLogs:Int = 10;

	static var _frameCount:Int = 0;
	static var _fpsTimer:Float = 0;
	static var _currentFps:Int = 0;
	static var _frameTime:Float = 0;

	/**
	 * Show debug overlay
	 */
	public static function show():Void
	{
		if (_visible) return;
		_visible = true;

		if (_overlay == null)
		{
			createOverlay();
		}

		Glue.stage.addChild(_overlay);
		Glue.stage.addEventListener(openfl.events.Event.ENTER_FRAME, onUpdate);
	}

	/**
	 * Hide debug overlay
	 */
	public static function hide():Void
	{
		if (!_visible) return;
		_visible = false;

		if (_overlay != null && _overlay.parent != null)
		{
			_overlay.parent.removeChild(_overlay);
		}

		Glue.stage.removeEventListener(openfl.events.Event.ENTER_FRAME, onUpdate);
	}

	/**
	 * Toggle visibility
	 */
	public static function toggle():Bool
	{
		if (_visible)
		{
			hide();
		}
		else
		{
			show();
		}
		return _visible;
	}

	/**
	 * Check if visible
	 */
	public static var isVisible(get, never):Bool;

	static function get_isVisible():Bool
	{
		return _visible;
	}

	/**
	 * Log a message
	 */
	public static function log(message:Dynamic):Void
	{
		var str = Std.string(message);
		var time = formatTime(Time.elapsed);
		_logs.unshift('[$time] $str');

		while (_logs.length > _maxLogs)
		{
			_logs.pop();
		}

		updateLog();

		// Also trace
		trace('[Debug] $str');
	}

	/**
	 * Watch a value (updated each frame)
	 */
	public static function watch(name:String, value:Dynamic):Void
	{
		_watches.set(name, value);
	}

	/**
	 * Remove a watch
	 */
	public static function unwatch(name:String):Void
	{
		_watches.remove(name);
	}

	/**
	 * Clear all watches
	 */
	public static function clearWatches():Void
	{
		_watches.clear();
	}

	/**
	 * Draw a debug point
	 */
	public static function point(x:Float, y:Float, color:Int = 0xFF0000, size:Float = 4):Void
	{
		if (_drawLayer == null) return;
		var g = _drawLayer.graphics;
		g.beginFill(color);
		g.drawCircle(x, y, size);
		g.endFill();
	}

	/**
	 * Draw a debug line
	 */
	public static function line(x1:Float, y1:Float, x2:Float, y2:Float, color:Int = 0xFF0000, thickness:Float = 1):Void
	{
		if (_drawLayer == null) return;
		var g = _drawLayer.graphics;
		g.lineStyle(thickness, color);
		g.moveTo(x1, y1);
		g.lineTo(x2, y2);
		g.lineStyle();
	}

	/**
	 * Draw a debug rectangle
	 */
	public static function rect(x:Float, y:Float, w:Float, h:Float, color:Int = 0xFF0000, fill:Bool = false):Void
	{
		if (_drawLayer == null) return;
		var g = _drawLayer.graphics;
		if (fill)
		{
			g.beginFill(color, 0.3);
		}
		else
		{
			g.lineStyle(1, color);
		}
		g.drawRect(x, y, w, h);
		if (fill)
		{
			g.endFill();
		}
		g.lineStyle();
	}

	/**
	 * Draw a debug circle
	 */
	public static function circle(x:Float, y:Float, radius:Float, color:Int = 0xFF0000, fill:Bool = false):Void
	{
		if (_drawLayer == null) return;
		var g = _drawLayer.graphics;
		if (fill)
		{
			g.beginFill(color, 0.3);
		}
		else
		{
			g.lineStyle(1, color);
		}
		g.drawCircle(x, y, radius);
		if (fill)
		{
			g.endFill();
		}
		g.lineStyle();
	}

	/**
	 * Draw text at position
	 */
	public static function text(str:String, x:Float, y:Float, color:Int = 0xFFFFFF):Void
	{
		// Simple implementation - in practice you'd want cached text
		if (_drawLayer == null) return;
		var g = _drawLayer.graphics;
		g.beginFill(0x000000, 0.7);
		g.drawRect(x, y, str.length * 7, 14);
		g.endFill();
	}

	/**
	 * Clear debug drawings
	 */
	public static function clearDraw():Void
	{
		if (_drawLayer != null)
		{
			_drawLayer.graphics.clear();
		}
	}

	static function createOverlay():Void
	{
		_overlay = new Sprite();

		var format = new TextFormat("_typewriter", 11, Palette.WHITE);

		// Stats panel (top-left)
		_statsText = createTextField(format);
		_statsText.x = 5;
		_statsText.y = 5;
		_overlay.addChild(_statsText);

		// Watch panel (top-right)
		_watchText = createTextField(format);
		_watchText.x = Glue.width - 200;
		_watchText.y = 5;
		_overlay.addChild(_watchText);

		// Log panel (bottom)
		_logText = createTextField(format);
		_logText.x = 5;
		_logText.y = Glue.height - 150;
		_overlay.addChild(_logText);

		// Draw layer
		_drawLayer = new Sprite();
		_overlay.addChild(_drawLayer);
	}

	static function createTextField(format:TextFormat):TextField
	{
		var tf = new TextField();
		tf.defaultTextFormat = format;
		tf.width = 200;
		tf.height = 150;
		tf.multiline = true;
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.background = true;
		tf.backgroundColor = 0x000000;
		tf.alpha = 0.8;
		return tf;
	}

	static function onUpdate(_):Void
	{
		// FPS calculation
		_frameCount++;
		_fpsTimer += Time.deltaTime;

		if (_fpsTimer >= 1.0)
		{
			_currentFps = _frameCount;
			_frameCount = 0;
			_fpsTimer = 0;
		}

		_frameTime = Time.deltaTime * 1000;

		// Clear draw layer
		_drawLayer.graphics.clear();

		// Update stats
		updateStats();

		// Update watches
		updateWatches();
	}

	static function updateStats():Void
	{
		var mem = Math.round(System.totalMemory / 1024 / 1024 * 10) / 10;

		var stats = 'FPS: $_currentFps\n';
		stats += 'Frame: ${Math.round(_frameTime * 10) / 10}ms\n';
		stats += 'Memory: ${mem}MB\n';
		stats += 'Time: ${formatTime(Time.elapsed)}\n';
		stats += 'Delta: ${Math.round(Time.deltaTime * 1000)}ms';

		_statsText.text = stats;
	}

	static function updateWatches():Void
	{
		var text = "WATCHES\n";
		text += "-------\n";

		for (name => value in _watches)
		{
			var str = Std.string(value);
			if (str.length > 15) str = str.substr(0, 15) + "...";
			text += '$name: $str\n';
		}

		_watchText.text = text;
	}

	static function updateLog():Void
	{
		if (_logText == null) return;

		var text = "LOG\n";
		text += "---\n";
		text += _logs.join("\n");

		_logText.text = text;
	}

	static function formatTime(seconds:Float):String
	{
		var mins = Std.int(seconds / 60);
		var secs = Std.int(seconds) % 60;
		var ms = Std.int((seconds - Std.int(seconds)) * 100);
		return '${StringTools.lpad(Std.string(mins), "0", 2)}:${StringTools.lpad(Std.string(secs), "0", 2)}.${StringTools.lpad(Std.string(ms), "0", 2)}';
	}
}
