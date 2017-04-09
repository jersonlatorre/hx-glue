package glue.display;

import glue.data.GLoader;
import glue.utils.GTime;
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
	
	public function new(spriteID:String = null, fps = 30):Void
	{
		super();

		if (spriteID != null)
		{
			_animations["default"] = { id: spriteID, fps: fps };
		}
	}

	public function addAnimation(value1:String, ?value2:String, ?fps:Int = 30):Dynamic 
	{
		if (value2 == null)
		{
			_animations["default"] = { id: value1, fps: fps };
		}
		else
		{
			_animations[value1] = { id: value2, fps: fps };
		}
		
		return this;
	}

	public function play(?name:String = "default"):Dynamic
	{
		if (animation == name) return null;
		
		while (_skin.numChildren > 0)
		{
			_skin.removeChildAt(0);
		}
		
		/**
		 *  If there is no any sprite.
		 */
		if (_animations[name] == null)
		{
			var a:Array<String> = cast(Type.getClassName(Type.getClass(this)), String).split(".");
			var className:String = a[a.length - 1];
			throw className + " -> A sprite ID must be provided!";
		}

		_sprite = new __GSpriteBase(_animations[name].id, _animations[name].fps);
		_sprite.addToLayer(_skin);
		if (_onEndAnimation != null) _sprite.onEndAnimation(_onEndAnimation);
		
		width = _sprite.width;
		height = _sprite.height;
		setAnchor(_anchor.x, _anchor.y);
		animation = name;

		return this;
	}

	public function onEndAnimation(callback:Dynamic):Dynamic
	{
		_onEndAnimation = callback;
		return this;
	}
	
	override public function preUpdate():Void 
	{
		if (_sprite != null) _sprite.preUpdate();
		super.preUpdate();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
}

@final class __GSpriteBase extends GEntity
{
	var _image:Bitmap;
	var _mask:Sprite;
	var _frames:Array<Dynamic> = new Array<Dynamic>();
	var _currentFrameIndex:Float = 0;
	var _fps:Int;
	var _onEndAnimation:Dynamic = null;
	
	public function new(spriteId:String, fps:Int = 30) 
	{
		super();
		_fps = fps;

		_frames = GLoader.getJson(spriteId + "_data").frames;
		
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
		return this;
	}
	
	override public function preUpdate():Void
	{
		_currentFrameIndex += _fps * GTime.deltaTime;
		
		if (_currentFrameIndex >= _frames.length && onEndAnimation != null)
		{
			if (_onEndAnimation != null) _onEndAnimation();
		}
		
		var rounded:Int = Math.floor(_currentFrameIndex) % _frames.length;
		
		_image.x = -_frames[rounded].frame.x;
		_image.y = -_frames[rounded].frame.y;
	}	
}