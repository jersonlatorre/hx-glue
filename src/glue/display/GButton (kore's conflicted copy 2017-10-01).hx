package glue.display;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import glue.assets.GLoader;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jerson La Torre
 */

class GButton extends GEntity
{
	var _frames:Array<Dynamic>;
	var _hitBmd:BitmapData;
	var _image:Bitmap;
	var _callbackClick:Dynamic = null;
	var _callbackMouseOver:Dynamic = null;
	var _callbackMouseDown:Dynamic = null;
	var _callbackMouseOut:Dynamic = null;
	var _callbackMouseEnter:Dynamic = null;
	var _isDown:Bool;
	var _isEnter:Bool;

	public function new()
	{
		super();
	}

	private function setFrames(frames:Array<Dynamic>)
	{
		_frames = frames;
	}

	private function sethitBmd(hitBmd:BitmapData)
	{
		_hitBmd = hitBmd;
	}

	private function setImage(image:Bitmap)
	{
		_image = image;
	}

	private function createListeners():Void
	{
		_skin.getChildAt(0).addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		_skin.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		_skin.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		_skin.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}

	static public function fromSpriteSheet(id:String):GButton
	{
		var button = new GButton();
		var data:Dynamic = GLoader.getJson(id + "__json");
		var frames:Array<Dynamic> = new Array<Dynamic>();
		for (i in 0...data.frames.length) frames.push(data.frames[i]);
		button.setFrames(frames);
		
		if (frames.length > 4)
		{
			throw "Button sprite sheets must have only 3 or 4 frames.";
		}

		button.width = frames[0].sourceSize.w * button.scale.x;
		button.height = frames[0].sourceSize.h * button.scale.y;

		var skin:Sprite = new Sprite();
		var hitBmd:BitmapData;
		var mask:Shape;
		var image:Bitmap = new Bitmap(GLoader.getImage(id + "__image"));

		image.smoothing = true;
		mask = new Shape();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(0, 0, button.width, button.height);
		mask.graphics.endFill();
		image.mask = mask;

		if (frames[3] != null)
		{
			hitBmd = new BitmapData(frames[3].frame.w, frames[3].frame.h, true, 0x00000000);
			hitBmd.copyPixels(image.bitmapData, new Rectangle(frames[3].frame.x, frames[3].frame.y, frames[3].frame.w, frames[3].frame.h) , new Point(0, 0), null, null, true);
		}
		else
		{
			var hit:Shape = new Shape();
			hit.graphics.beginFill(0xFF0000);
			hit.graphics.drawRect(0, 0, frames[0].sourceSize.w, frames[0].sourceSize.h);
			hit.graphics.endFill();
			hitBmd = new BitmapData(frames[0].sourceSize.w, frames[0].sourceSize.h, true, 0x00000000);
			hitBmd.draw(hit);
		}

		skin.addChild(image);
		skin.addChild(mask);

		button.setImage(image);
		button.sethitBmd(hitBmd);
		button.setSkin(skin);
		button.createListeners();

		button.setNormal();

		return button;
	}

	function _onMouseMove(e:MouseEvent)
	{
		if (_hitBmd.getPixel32(Std.int(e.localX), Std.int(e.localY)) != 0)
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
		if (_hitBmd.getPixel32(Std.int(e.localX), Std.int(e.localY)) != 0)
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
		if (_hitBmd.getPixel32(Std.int(e.localX), Std.int(e.localY)) != 0 && _isDown)
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

	override public function destroy()
	{
		_skin.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		_skin.removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		_skin.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		_skin.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		
		super.destroy();
	}
}