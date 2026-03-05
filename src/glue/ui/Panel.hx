package glue.ui;

import glue.display.Entity;
import glue.style.Palette;
import openfl.display.Graphics;

/**
 * Container panel with Glue aesthetic.
 *
 * Usage:
 *   var panel = new Panel(300, 200);
 *   panel.add(new Button("OK", 80, 30));
 *   add(panel.at(100, 100));
 */
class Panel extends Entity
{
	var _width:Float;
	var _height:Float;

	var _bgColor:Int = Palette.MIDNIGHT;
	var _borderColor:Null<Int> = Palette.STORM;
	var _borderWidth:Float = 1;
	var _borderRadius:Float = 4;
	var _shadowOffset:Float = 0;
	var _shadowColor:Int = Palette.VOID;

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

	/**
	 * Set background color
	 */
	public function background(color:Int):Panel
	{
		_bgColor = color;
		redraw();
		return this;
	}

	/**
	 * Set border
	 */
	public function border(color:Int, width:Float = 1):Panel
	{
		_borderColor = color;
		_borderWidth = width;
		redraw();
		return this;
	}

	/**
	 * Remove border
	 */
	public function noBorder():Panel
	{
		_borderColor = null;
		redraw();
		return this;
	}

	/**
	 * Set corner radius
	 */
	public function rounded(radius:Float):Panel
	{
		_borderRadius = radius;
		redraw();
		return this;
	}

	/**
	 * Add drop shadow
	 */
	public function shadow(offset:Float = 4):Panel
	{
		_shadowOffset = offset;
		redraw();
		return this;
	}

	/**
	 * Make transparent (just border)
	 */
	public function transparent():Panel
	{
		_bgColor = -1;
		redraw();
		return this;
	}

	function redraw():Void
	{
		var g:Graphics = _skin.graphics;
		g.clear();

		// Shadow
		if (_shadowOffset > 0)
		{
			g.beginFill(_shadowColor, 0.3);
			g.drawRoundRect(_shadowOffset, _shadowOffset, _width, _height, _borderRadius, _borderRadius);
			g.endFill();
		}

		// Border
		if (_borderColor != null)
		{
			g.lineStyle(_borderWidth, _borderColor);
		}

		// Background
		if (_bgColor >= 0)
		{
			g.beginFill(_bgColor);
		}

		g.drawRoundRect(0, 0, _width, _height, _borderRadius, _borderRadius);

		if (_bgColor >= 0)
		{
			g.endFill();
		}

		g.lineStyle();
	}
}
