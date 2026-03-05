package glue.ui;

import glue.display.Entity;
import glue.input.Input;
import glue.style.Palette;
import openfl.display.Graphics;

/**
 * Slider control with Glue aesthetic.
 *
 * Usage:
 *   var volume = new Slider(0, 1, 0.5, 150);
 *   volume.onChange = (v) -> Audio.setVolume(v);
 *   add(volume.at(100, 200));
 */
class Slider extends Entity
{
	public var value(default, set):Float;
	public var min:Float;
	public var max:Float;
	public var onChange:Float->Void;

	var _width:Float;
	var _height:Float = 20;
	var _trackHeight:Float = 6;
	var _handleSize:Float = 16;

	var _trackColor:Int = Palette.MIDNIGHT;
	var _fillColor:Int = Palette.PRIMARY;
	var _handleColor:Int = Palette.WHITE;

	var _isDragging:Bool = false;

	public function new(min:Float, max:Float, initial:Float, w:Float)
	{
		this.min = min;
		this.max = max;
		this.value = initial;
		_width = w;
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
		value = Math.max(min, Math.min(max, v));
		redraw();
		return value;
	}

	/**
	 * Set slider colors
	 */
	public function colors(track:Int, fill:Int, handle:Int):Slider
	{
		_trackColor = track;
		_fillColor = fill;
		_handleColor = handle;
		redraw();
		return this;
	}

	override public function update():Void
	{
		var mx = Input.mouseX - position.x;
		var my = Input.mouseY - position.y;

		var inBounds = mx >= 0 && mx <= _width && my >= 0 && my <= _height;

		if (Input.isMouseDown() && inBounds)
		{
			_isDragging = true;
		}

		if (Input.isMouseUp())
		{
			_isDragging = false;
		}

		if (_isDragging && Input.isMousePressed())
		{
			var normalized = Math.max(0, Math.min(1, mx / _width));
			var newValue = min + normalized * (max - min);

			if (newValue != value)
			{
				value = newValue;
				if (onChange != null)
				{
					onChange(value);
				}
			}
		}
	}

	function redraw():Void
	{
		var g:Graphics = _skin.graphics;
		g.clear();

		var trackY = (_height - _trackHeight) / 2;
		var normalized = (value - min) / (max - min);
		var fillWidth = normalized * _width;
		var handleX = normalized * _width;

		// Track background
		g.beginFill(_trackColor);
		g.drawRoundRect(0, trackY, _width, _trackHeight, _trackHeight, _trackHeight);
		g.endFill();

		// Filled portion
		g.beginFill(_fillColor);
		g.drawRoundRect(0, trackY, fillWidth, _trackHeight, _trackHeight, _trackHeight);
		g.endFill();

		// Handle
		g.beginFill(_handleColor);
		g.drawCircle(handleX, _height / 2, _handleSize / 2);
		g.endFill();
	}

	/**
	 * Get normalized value (0-1)
	 */
	public var normalized(get, never):Float;

	function get_normalized():Float
	{
		return (value - min) / (max - min);
	}
}
