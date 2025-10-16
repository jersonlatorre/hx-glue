package glue.display;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import glue.assets.GLoader;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jerson La Torre
 */

class GButton extends GEntity
{
	var _image:Bitmap;
	var _hitBmd:BitmapData;
	var _mask:Shape;
	var _frames:Array<Dynamic> = new Array<Dynamic>();
	var _callbackClick:Dynamic = null;
	var _callbackMouseOver:Dynamic = null;
	var _callbackMouseDown:Dynamic = null;
	var _callbackMouseOut:Dynamic = null;
	var _callbackMouseEnter:Dynamic = null;
	var _isDown:Bool;
	var _isEnter:Bool;

	public function new(id:String)
	{
		super();

		var data:Dynamic = GLoader.getJson(id + "_data");
		for (i in 0...data.frames.length) _frames.push(data.frames[i]);

		width = _frames[0].sourceSize.w * scale.x;
		height = _frames[0].sourceSize.h * scale.y;
		
		_image = new Bitmap(GLoader.getImage(id));
		_image.smoothing = true;
		_mask = new Shape();
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
			var _hit:Shape = new Shape();
			_hit.graphics.beginFill(0xFF0000);
			_hit.graphics.drawRect(0, 0, _frames[0].sourceSize.w, _frames[0].sourceSize.h);
			_hit.graphics.endFill();
			_hitBmd = new BitmapData(_frames[0].sourceSize.w, _frames[0].sourceSize.h, true, 0x00000000);
			_hitBmd.draw(_hit);
		}
		
		_skin.addChild(_image);
		_skin.addChild(_mask);

		setNormal();

		_skin.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		_skin.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		_skin.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		_skin.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}

	function _onMouseMove(e:MouseEvent)
	{
		if (isWithinHitArea(e.localX, e.localY))
		{
			if (_callbackMouseOver != null) _callbackMouseOver();

			if (!_isEnter)
			{
				_isEnter = true;
				if (_callbackMouseEnter != null) _callbackMouseEnter();
			}

			if (!e.buttonDown) setOver();
			_skin.buttonMode = true;
		}
		else
		{
			setNormal();
			_skin.buttonMode = false;

			if (_isEnter)
			{
				if (_callbackMouseOut != null) _callbackMouseOut();
			}

			_isEnter = false;
		}
	}

	function _onMouseOut(e:MouseEvent)
	{
		setNormal();
		_isDown = false;
		_skin.buttonMode = false;

		if (_isEnter)
		{
			if (_callbackMouseOut != null) _callbackMouseOut();
		}
		
		_isEnter = false;
	}

	function _onMouseDown(e:MouseEvent)
	{
		if (isWithinHitArea(e.localX, e.localY))
		{
			if (_callbackMouseDown != null) _callbackMouseDown();
			_isDown = true;
			setDown();
		}
		else
		{
			e.preventDefault();
		}
	}

	function _onMouseUp(e:MouseEvent)
	{
		if (isWithinHitArea(e.localX, e.localY) && _isDown)
		{
			setOver();
			_skin.buttonMode = false;
			if (_callbackClick != null) _callbackClick();
		}
		else
		{
			e.preventDefault();
		}

		_isDown = false;
	}
	
	public function onClick(callback:Dynamic):GButton
	{
		_callbackClick = callback;
		return this;
	}

	public function onMouseOver(callback:Dynamic):GButton
	{
		_callbackMouseOver = callback;
		return this;
	}

	public function onMouseDown(callback:Dynamic):GButton
	{
		_callbackMouseDown = callback;
		return this;
	}

	public function onMouseOut(callback:Dynamic):GButton
	{
		_callbackMouseOut = callback;
		return this;
	}

	public function onMouseEnter(callback:Dynamic):GButton
	{
		_callbackMouseEnter = callback;
		return this;
	}

	function setNormal()
	{
		_image.x = -_frames[0].frame.x;
		_image.y = -_frames[0].frame.y;
	}

	function setOver()
	{
		_image.x = -_frames[1].frame.x;
		_image.y = -_frames[1].frame.y;
	}

	function setDown()
	{
		_image.x = -_frames[2].frame.x;
		_image.y = -_frames[2].frame.y;
	}

	inline function isWithinHitArea(x:Float, y:Float):Bool
	{
		if (_hitBmd == null) return false;

		var px = Std.int(x);
		var py = Std.int(y);

		if (px < 0 || py < 0 || px >= _hitBmd.width || py >= _hitBmd.height)
		{
			return false;
		}

		return _hitBmd.getPixel32(px, py) != 0;
	}

	override public function destroy()
	{
		_skin.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		_skin.removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		_skin.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		_skin.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		
		super.destroy();
	}
}
