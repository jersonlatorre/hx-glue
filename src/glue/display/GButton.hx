package glue.display;

import glue.utils.GSignal;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import glue.assets.GLoader;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.events.MouseEvent;

/**
 * Interactive button with hover, press states and type-safe callbacks
 * @author Jerson La Torre
 */

class GButton extends GEntity
{
	var _image:Bitmap;
	var _hitBmd:BitmapData;
	var _mask:Shape;
	var _frames:Array<Dynamic> = new Array<Dynamic>();

	public final onClick:GSignal0 = new GSignal0();
	public final onMouseOver:GSignal0 = new GSignal0();
	public final onMouseDown:GSignal0 = new GSignal0();
	public final onMouseOut:GSignal0 = new GSignal0();
	public final onMouseEnter:GSignal0 = new GSignal0();

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
			onMouseOver.dispatch();

			if (!_isEnter)
			{
				_isEnter = true;
				onMouseEnter.dispatch();
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
				onMouseOut.dispatch();
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
			onMouseOut.dispatch();
		}

		_isEnter = false;
	}

	function _onMouseDown(e:MouseEvent)
	{
		if (isWithinHitArea(e.localX, e.localY))
		{
			onMouseDown.dispatch();
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
			onClick.dispatch();
		}
		else
		{
			e.preventDefault();
		}

		_isDown = false;
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

		onClick.clear();
		onMouseOver.clear();
		onMouseDown.clear();
		onMouseOut.clear();
		onMouseEnter.clear();

		super.destroy();
	}
}
