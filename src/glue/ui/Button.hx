package glue.ui;

import glue.display.Entity;
import glue.style.Palette;
import glue.input.Input;
import openfl.display.Graphics;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * Styled button with Glue aesthetic.
 *
 * Usage:
 *   var btn = new Button("Play", 120, 40, () -> gotoScene(GameScene));
 *   add(btn.at(100, 200));
 */
class Button extends Entity
{
	public var text(default, set):String;
	public var enabled:Bool = true;

	var _width:Float;
	var _height:Float;
	var _callback:Void->Void;
	var _textField:TextField;

	var _bgColor:Int = Palette.PRIMARY;
	var _hoverColor:Int = Palette.SKY;
	var _pressColor:Int = Palette.ROYAL;
	var _disabledColor:Int = Palette.STORM;
	var _textColor:Int = Palette.WHITE;
	var _borderRadius:Float = 4;

	var _isHovered:Bool = false;
	var _isPressed:Bool = false;

	public function new(label:String, w:Float, h:Float, ?onClick:Void->Void)
	{
		_width = w;
		_height = h;
		_callback = onClick;
		text = label;
		super();
	}

	override public function init():Void
	{
		width = _width;
		height = _height;

		// Create text
		var format = new TextFormat();
		format.font = "_sans";
		format.size = 14;
		format.color = _textColor;
		format.align = TextFormatAlign.CENTER;

		_textField = new TextField();
		_textField.defaultTextFormat = format;
		_textField.text = text;
		_textField.width = _width;
		_textField.height = _height;
		_textField.y = (_height - 20) / 2;
		_textField.selectable = false;
		_textField.mouseEnabled = false;

		_skin.addChild(_textField);

		redraw();
	}

	function set_text(value:String):String
	{
		text = value;
		if (_textField != null)
		{
			_textField.text = value;
		}
		return value;
	}

	/**
	 * Set button colors
	 */
	public function colors(bg:Int, hover:Int, press:Int):Button
	{
		_bgColor = bg;
		_hoverColor = hover;
		_pressColor = press;
		redraw();
		return this;
	}

	/**
	 * Set text color
	 */
	public function textColor(c:Int):Button
	{
		_textColor = c;
		if (_textField != null)
		{
			var format = _textField.defaultTextFormat;
			format.color = c;
			_textField.setTextFormat(format);
		}
		return this;
	}

	/**
	 * Set border radius
	 */
	public function rounded(radius:Float):Button
	{
		_borderRadius = radius;
		redraw();
		return this;
	}

	/**
	 * Set click callback
	 */
	public function onClick(callback:Void->Void):Button
	{
		_callback = callback;
		return this;
	}

	override public function update():Void
	{
		if (!enabled)
		{
			if (_isHovered || _isPressed)
			{
				_isHovered = false;
				_isPressed = false;
				redraw();
			}
			return;
		}

		var mx = Input.mouseX - position.x;
		var my = Input.mouseY - position.y;

		var wasHovered = _isHovered;
		var wasPressed = _isPressed;

		_isHovered = mx >= 0 && mx <= _width && my >= 0 && my <= _height;
		_isPressed = _isHovered && Input.isMousePressed();

		if (_isHovered && Input.isMouseDown())
		{
			if (_callback != null)
			{
				_callback();
			}
		}

		if (_isHovered != wasHovered || _isPressed != wasPressed)
		{
			redraw();
		}
	}

	function redraw():Void
	{
		var g:Graphics = _skin.graphics;
		g.clear();

		var color:Int;
		if (!enabled)
		{
			color = _disabledColor;
		}
		else if (_isPressed)
		{
			color = _pressColor;
		}
		else if (_isHovered)
		{
			color = _hoverColor;
		}
		else
		{
			color = _bgColor;
		}

		g.beginFill(color);
		g.drawRoundRect(0, 0, _width, _height, _borderRadius, _borderRadius);
		g.endFill();
	}
}
