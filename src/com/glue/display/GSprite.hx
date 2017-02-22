package com.glue.display;
import com.glue.data.GLoader;
import com.glue.utils.GTime;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import haxe.Timer;

/**
 * ...
 * @author one
 */

class GSprite extends GEntity
{
	var _image:Bitmap;
	var _mask:Sprite;
	var _frames:Array<Dynamic> = new Array<Dynamic>();
	var _currentFrameIndex:Float = 0;
	var _fps:Int;
	
	public var onEndAnimation:Dynamic = null;
	
	public function new(spriteId:String, fps:Int = 30) 
	{
		super();
		_fps = fps;

		var data:Dynamic = GLoader.getSpriteData(spriteId);
		for (i in 0...data.frames.length) _frames.push(data.frames[i]);
		
		_width = _frames[0].sourceSize.w * _scaleX;
		_height = _frames[0].sourceSize.h * _scaleY;
		
		_image = GLoader.getImage(spriteId);
		_mask = new Sprite();
		_mask.graphics.beginFill(0);
		_mask.graphics.drawRect(0, 0, _width, _height);
		_mask.graphics.endFill();
		_image.mask = _mask;
		
		_skin.addChild(_image);
		_skin.addChild(_mask);
	}
	
	override public function update():Void 
	{
		_currentFrameIndex += _fps * GTime.deltaTime / 1000;

		var rounded:Int = Math.floor(_currentFrameIndex) % _frames.length;
		if (rounded >= _frames.length && onEndAnimation != null) onEndAnimation();
		
		_image.x = -_frames[rounded].frame.x;
		_image.y = -_frames[rounded].frame.y;
		
		super.update();
	}	
}