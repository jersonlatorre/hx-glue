package glue.ui;

import glue.display.Entity;
import glue.style.Palette;
import openfl.display.Graphics;

/**
 * Progress bar with Glue aesthetic.
 *
 * Usage:
 *   var health = new ProgressBar(200, 20);
 *   health.value = 0.75;
 *   add(health.at(100, 50));
 */
class ProgressBar extends Entity
{
	public var value(default, set):Float = 1;
	public var maxValue:Float = 1;

	var _width:Float;
	var _height:Float;
	var _padding:Float = 2;

	var _bgColor:Int = Palette.MIDNIGHT;
	var _fillColor:Int = Palette.SUCCESS;
	var _borderColor:Null<Int> = null;
	var _borderRadius:Float = 2;

	public function new(w:Float, h:Float)
	{
		_width = w;
		_height = h;
		super();
	}

	override public function init():Void
	{
		width = _width;
		height = _height;
		redraw();
	}

	function set_value(v:Float):Float
	{
		value = Math.max(0, Math.min(maxValue, v));
		redraw();
		return value;
	}

	/**
	 * Set colors
	 */
	public function colors(bg:Int, fill:Int):ProgressBar
	{
		_bgColor = bg;
		_fillColor = fill;
		redraw();
		return this;
	}

	/**
	 * Add border
	 */
	public function border(color:Int):ProgressBar
	{
		_borderColor = color;
		redraw();
		return this;
	}

	/**
	 * Set corner radius
	 */
	public function rounded(radius:Float):ProgressBar
	{
		_borderRadius = radius;
		redraw();
		return this;
	}

	/**
	 * Use health bar colors (green -> yellow -> red)
	 */
	public function asHealth():ProgressBar
	{
		// Color will be set dynamically in redraw
		return this;
	}

	function redraw():Void
	{
		var g:Graphics = _skin.graphics;
		g.clear();

		// Border
		if (_borderColor != null)
		{
			g.lineStyle(1, _borderColor);
		}

		// Background
		g.beginFill(_bgColor);
		g.drawRoundRect(0, 0, _width, _height, _borderRadius, _borderRadius);
		g.endFill();
		g.lineStyle();

		// Fill
		var normalized = value / maxValue;
		var fillWidth = (_width - _padding * 2) * normalized;

		if (fillWidth > 0)
		{
			// Dynamic health color
			var fillColor = _fillColor;
			if (normalized < 0.25)
			{
				fillColor = Palette.DANGER;
			}
			else if (normalized < 0.5)
			{
				fillColor = Palette.WARNING;
			}

			g.beginFill(fillColor);
			g.drawRoundRect(_padding, _padding, fillWidth, _height - _padding * 2, _borderRadius, _borderRadius);
			g.endFill();
		}
	}

	/**
	 * Get normalized value (0-1)
	 */
	public var normalized(get, never):Float;

	function get_normalized():Float
	{
		return value / maxValue;
	}

	/**
	 * Set value as percentage (0-100)
	 */
	public function setPercent(percent:Float):Void
	{
		value = (percent / 100) * maxValue;
	}
}
