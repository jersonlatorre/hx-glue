package glue.ui;

import glue.display.Entity;
import glue.style.Palette;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * Text label with Glue aesthetic.
 *
 * Usage:
 *   var title = new Label("Hello World", 24);
 *   add(title.at(100, 50));
 *
 *   var score = new Label("0", 32).color(Palette.GOLD).centered();
 */
class Label extends Entity
{
	public var text(default, set):String;

	var _textField:TextField;
	var _format:TextFormat;
	var _size:Int;
	var _color:Int = Palette.TEXT;

	public function new(text:String, size:Int = 16)
	{
		this.text = text;
		_size = size;
		super();
	}

	override public function init():Void
	{
		_format = new TextFormat();
		_format.font = "_sans";
		_format.size = _size;
		_format.color = _color;

		_textField = new TextField();
		_textField.defaultTextFormat = _format;
		_textField.text = text;
		_textField.autoSize = openfl.text.TextFieldAutoSize.LEFT;
		_textField.selectable = false;
		_textField.mouseEnabled = false;

		_skin.addChild(_textField);

		updateSize();
	}

	function set_text(value:String):String
	{
		text = value;
		if (_textField != null)
		{
			_textField.text = value;
			updateSize();
		}
		return value;
	}

	function updateSize():Void
	{
		width = _textField.textWidth + 4;
		height = _textField.textHeight + 4;
	}

	/**
	 * Set text color
	 */
	public function color(c:Int):Label
	{
		_color = c;
		if (_format != null)
		{
			_format.color = c;
			_textField.setTextFormat(_format);
		}
		return this;
	}

	/**
	 * Set font size
	 */
	public function size(s:Int):Label
	{
		_size = s;
		if (_format != null)
		{
			_format.size = s;
			_textField.setTextFormat(_format);
			updateSize();
		}
		return this;
	}

	/**
	 * Make bold
	 */
	public function bold():Label
	{
		if (_format != null)
		{
			_format.bold = true;
			_textField.setTextFormat(_format);
		}
		return this;
	}

	/**
	 * Make italic
	 */
	public function italic():Label
	{
		if (_format != null)
		{
			_format.italic = true;
			_textField.setTextFormat(_format);
		}
		return this;
	}

	/**
	 * Center text alignment
	 */
	public function centered():Label
	{
		anchor.set(0.5, 0.5);
		return this;
	}

	/**
	 * Right align
	 */
	public function rightAlign():Label
	{
		anchor.set(1, 0);
		return this;
	}

	/**
	 * Set fixed width (for multiline)
	 */
	public function wrap(maxWidth:Float):Label
	{
		_textField.autoSize = openfl.text.TextFieldAutoSize.NONE;
		_textField.width = maxWidth;
		_textField.wordWrap = true;
		_textField.multiline = true;
		updateSize();
		return this;
	}
}
