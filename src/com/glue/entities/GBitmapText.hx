package com.glue.entities;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import com.glue.data.GDataManager;
import com.glue.data.GImageManager;
import com.glue.entities.GTextAlignMode;
import com.glue.utils.GRectBounds;
import com.glue.utils.GVector2D;
import flash.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author uno
 * 
 */

class GBitmapText extends GEntity
{	
	var _textAlignMode:Int;
	var _fontXML:Xml;
	var _fontImage:BitmapData;
	var _font:BitmapFont;
	var _bitmapText:BitmapTextField;
	
	public var text(default, set):String;
	public var textWidth(get, set):Float;
	public var textHeight(get, set):Float;
	
	public function new(id:String, textAlignMode:Int = 0):Void
	{
		super(GAlignMode.TOP_LEFT);
		
		_textAlignMode = textAlignMode;
		
		_fontXML = Xml.parse(GDataManager.getText(id));
		_fontImage = GImageManager.getImage(id).bitmapData;
		_font = BitmapFont.fromAngelCode(_fontImage, _fontXML);
		
		_bitmapText = new BitmapTextField(_font);
		_bitmapText.smoothing = true;
		
		switch(textAlignMode)
		{
			case GTextAlignMode.LEFT:
			{
				_bitmapText.alignment = BitmapTextAlign.LEFT;
			}
			
			case GTextAlignMode.RIGHT:
			{
				_bitmapText.alignment = BitmapTextAlign.RIGHT;
			}
			
			case GTextAlignMode.CENTER:
			{
				_bitmapText.alignment = BitmapTextAlign.CENTER;
			}
		}
		
		canvas.addChild(_bitmapText);
	}
	
	override public function update():Void 
	{
		super.update();
		
		width = _bitmapText.width;
		height = _bitmapText.height;
		textWidth = _bitmapText.textWidth;
		textHeight = _bitmapText.textHeight;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		//_bitmapText = null;
		//_font = null;
		//_fontImage = null;
		//_fontXML = null;
	}
	
	public function set_text(s:String)
	{
		_bitmapText.text = s;
		text = s;
		
		return s;
	}
	
	public function get_textWidth():Float
	{
		return _bitmapText.textWidth;
	}
	
	public function get_textHeight():Float
	{
		return _bitmapText.textHeight;
	}
	
	public function set_textWidth(value:Float):Float
	{
		return value;
	}
	
	public function set_textHeight(value:Float):Float
	{
		return value;
	}
}