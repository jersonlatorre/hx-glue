package glue.display;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import glue.data.GLoader;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jerson La Torre
 */

class GButton extends GEntity
{
	var _image:Bitmap;
	var _hitBmd:BitmapData;
	var _mask:Sprite;
	var _frames:Array<Dynamic> = new Array<Dynamic>();
	var _callback:Dynamic;
	var _isDown:Bool;

	public function new(spriteId:String = null):Void
	{
		super();

		var data:Dynamic = GLoader.getJson(spriteId + "_data");
		for (i in 0...data.frames.length) _frames.push(data.frames[i]);

		width = _frames[0].sourceSize.w * _scaleX;
		height = _frames[0].sourceSize.h * _scaleY;
		
		_image = GLoader.getImage(spriteId);
		_image.smoothing = true;
		_mask = new Sprite();
		_mask.graphics.beginFill(0);
		_mask.graphics.drawRect(0, 0, width, height);
		_mask.graphics.endFill();
		_image.mask = _mask;

		if (_frames.length > 4)
		{
			throw "Button class must have only 3 or 4 frames.";
		}

		if (_frames[3] != null)
		{
			_hitBmd = new BitmapData(_frames[3].frame.w, _frames[3].frame.h, true, 0x00000000);
			_hitBmd.copyPixels(_image.bitmapData, new Rectangle(_frames[3].frame.x, _frames[3].frame.y, _frames[3].frame.w, _frames[3].frame.h) , new Point(0, 0), null, null, true);
		}
		else
		{
			var _hit:Sprite = new Sprite();
			_hit.graphics.beginFill(0xFF0000);
			_hit.graphics.drawRect(0, 0, _frames[0].sourceSize.w, _frames[0].sourceSize.h);
			_hit.graphics.endFill();
			_hitBmd = new BitmapData(_frames[0].sourceSize.w, _frames[0].sourceSize.h, true, 0x00000000);
			_hitBmd.draw(_hit);
		}
		
		_skin.addChild(_image);
		_skin.addChild(_mask);

		setNormal();

		_skin.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):Void
		{
			if (_hitBmd.getPixel32(Std.int(e.localX), Std.int(e.localY)) != 0)
			{
				if (!e.buttonDown) setOver();
				_skin.buttonMode = true;
			}
			else
			{
				setNormal();
				_skin.buttonMode = false;
			}
		});

		_skin.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):Void
		{
				setNormal();
				_isDown = false;
				_skin.buttonMode = false;
		});

		_skin.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):Void
		{
			if (_hitBmd.getPixel32(Std.int(e.localX), Std.int(e.localY)) != 0)
			{
				_isDown = true;
				setDown();
			}
			else
			{
				e.preventDefault();
			}
		});

		_skin.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):Void
		{
			if (_hitBmd.getPixel32(Std.int(e.localX), Std.int(e.localY)) != 0 && _isDown)
			{
				setOver();
				_skin.buttonMode = false;
				if (_callback != null) _callback();
			}
			else
			{
				e.preventDefault();
			}

			_isDown = false;
		});
	}
	
	public function onClick(callback:Dynamic):GButton
	{
		_callback = callback;
		return this;
	}

	function setNormal():Void
	{
		_image.x = -_frames[0].frame.x;
		_image.y = -_frames[0].frame.y;
	}

	function setOver():Void
	{
		_image.x = -_frames[1].frame.x;
		_image.y = -_frames[1].frame.y;
	}

	function setDown():Void
	{
		_image.x = -_frames[2].frame.x;
		_image.y = -_frames[2].frame.y;
	}
}