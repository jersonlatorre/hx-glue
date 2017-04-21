package glue.display;

import glue.assets.GLoader;
import glue.utils.GTime;
import glue.utils.GTools;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GSprite extends GEntity
{
	public var animation:String = "";
	var _onEndAnimation:Dynamic = null;
	
	var _animations:Map<String, Dynamic> = new Map<String, Dynamic>();
	var _sprite:__GSpriteBase;
	
	public function new()
	{
		super();
	}

	public function addAnimation(animationId:String, assetId:String, ?fps:Int = 30, ?loop:Bool = true) 
	{
		_animations[animationId] = { id: assetId, fps: fps, loop: loop };
	}

	public function play(name:String)
	{
		if (animation == name) return null;
		
		while (_skin.numChildren > 0)
		{
			_skin.removeChildAt(0);
		}
		
		if (_animations[name] == null)
		{
			throw '${ GTools.getClassName(this) } -> a sprite ID must be provided!';
		}
		
		_sprite = new __GSpriteBase(_animations[name].id, _animations[name].fps, _animations[name].loop);
		_sprite.addToLayer(_skin);
		_sprite.adjustPosition();
		if (_onEndAnimation != null) _sprite.onEndAnimation(_onEndAnimation);
		
		width = _sprite.width;
		height = _sprite.height;
		animation = name;

		return null;
	}

	public function onEndAnimation(callback:Dynamic)
	{
		_onEndAnimation = callback;
	}
	
	override public function preUpdate() 
	{
		if (_sprite != null) _sprite.preUpdate();
		super.preUpdate();
	}
	
	override public function destroy() 
	{
		_sprite.removeFromLayer(_skin);
		_sprite.destroy();
		super.destroy();
	}
}

@:final class __GSpriteBase extends GEntity
{
	var _image:Bitmap;
	var _mask:Sprite;
	var _frames:Array<Dynamic> = new Array<Dynamic>();
	var _framesLength:Int;
	var _currentFrameIndex:Float = 0;
	var _fps:Int;
	var _loop:Bool;
	var _isPaused:Bool = false;
	var _onEndAnimation:Dynamic = null;
	
	public function new(spriteId:String, fps:Int = 30, loop:Bool = true) 
	{
		super();

		_fps = fps;
		_loop = loop;

		_frames = GLoader.getJson(spriteId + "_data").frames;
		_framesLength = _frames.length;
		
		width = _frames[0].sourceSize.w * _scaleX;
		height = _frames[0].sourceSize.h * _scaleY;
		
		_image = GLoader.getImage(spriteId);
		_mask = new Sprite();
		_mask.graphics.beginFill(0);
		_mask.graphics.drawRect(0, 0, width, height);
		_mask.graphics.endFill();
		_image.mask = _mask;
		
		_skin.addChild(_image);
		_skin.addChild(_mask);
	}
	
	public function onEndAnimation(callback:Dynamic)
	{
		_onEndAnimation = callback;
	}

	@:allow(glue.display.GSprite.play)
	function adjustPosition()
	{
		_image.x = -Std.int(_frames[0].frame.x);
		_image.y = -Std.int(_frames[0].frame.y);
	}
	
	override public function preUpdate()
	{
		if (_isPaused) return;

		_currentFrameIndex += _fps * GTime.deltaTime;
		
		if(_currentFrameIndex >= _framesLength)
		{
			if (!_loop) _isPaused = true;
			if (_onEndAnimation != null) _onEndAnimation();
		}
		
		var rounded:Int = Std.int((_currentFrameIndex) % _framesLength);
		_image.x = -Std.int(_frames[rounded].frame.x);
		_image.y = -Std.int(_frames[rounded].frame.y);
	}

	override public function destroy()
	{
		_skin.removeChild(_image);
		_skin.removeChild(_mask);
		super.destroy();
		_image.bitmapData.dispose();
		_image.bitmapData.disposeImage();
		_image = null;
		_mask = null;
	}
}