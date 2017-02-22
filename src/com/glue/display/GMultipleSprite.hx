package com.glue.display;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GMultipleSprite extends GEntity
{
	public var animation:String = "";
	public var onEndAnimation:Dynamic = null;
	
	var _animations:Map<String, Dynamic> = new Map<String, Dynamic>();
	var _atlasId:String;
	var _sprite:GSprite;
	
	public function new(atlasId):Void
	{
		super();
		_atlasId = atlasId;
	}
	
	public function addAnimation(name:String, animationId:String, fps:Int = 30):GMultipleSprite 
	{
		_animations[name] = { id: animationId, fps: fps };
		return this;
	}

	public function setAnimation(name:String):Void 
	{
		if (animation == name) return;
		
		while (_skin.numChildren > 0)
		{
			_skin.removeChildAt(0);
		}
		
		_sprite = new GSprite(_animations[name].id, _animations[name].fps);
		_sprite.addToLayer(_skin);
		_sprite.setAnchor(0, 0);
		_width = _sprite._width;
		_height = _sprite._height;
		animation = name;
		
		_sprite.onEndAnimation = onEndAnimation;
	}
	
	override public function update():Void 
	{
		if (_sprite != null) _sprite.update();
		super.update();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
}