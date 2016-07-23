package com.glue.display;
import com.glue.data.GLoader;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author one
 */
class GSprite extends GEntity
{
	var _image:Bitmap;
	var _mask:Sprite;
	var _frames:Array<Dynamic> = new Array<Dynamic>();
	var _currentFrameIndex:Int = 0;
	var _fps:Int;
	var _deltaTimeAux:Float;
	
	public function new(atlasId:String, spriteId:String, fps:Int = 30) 
	{
		super();
		
		_fps = fps;
		_deltaTimeAux = _fps / 60;
		
		var data:Dynamic = GLoader.getAtlasData(atlasId);
		
		for (i in 0...data.frames.length)
		{
			var filename:String = data.frames[i].filename;
			filename = filename.substring(0, filename.length - 4);
			
			if (filename == spriteId) _frames.push(data.frames[i]);
		}
		
		_width = _frames[0].sourceSize.w * _scaleX;
		_height = _frames[0].sourceSize.h * _scaleY;
		
		_image = GLoader.getImage(atlasId);
		_mask = new Sprite();
		_mask.graphics.beginFill(0);
		_mask.graphics.drawRect(0, 0, _width, _height);
		_mask.graphics.endFill();
		_image.mask = _mask;
		_skin.addChild(_image);
		
		trace(_frames[0].frame.x, _frames[0].frame.y);
		_mask.x = _frames[0].frame.x;
		_mask.y = _frames[0].frame.y;
		_image.x = -_frames[0].frame.x;
		_image.y = _frames[0].frame.y;
		
		update();
		
	}
	
	override public function update():Void 
	{
		_currentFrameIndex += 1;
		_currentFrameIndex = Math.floor(_currentFrameIndex) % _frames.length;
		_mask.x = _frames[_currentFrameIndex].frame.x;
		_mask.y = _frames[_currentFrameIndex].frame.y;
		_image.x = -_frames[_currentFrameIndex].frame.x;
		_image.y = _frames[_currentFrameIndex].frame.y;
		super.update();
	}
	
}