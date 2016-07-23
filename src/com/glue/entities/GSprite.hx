package com.glue.entities;
import com.glue.data.GImageManager;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author uno
 * 
 */

class GSprite extends GEntity
{
	public var animation:String = "";
	
	var _animations:Map<String, String> = new Map<String, String>();
	var _sprite:GSpriteAux;
	
	public function new(alignType:Int = 0):Void
	{
		super(alignType);
	}
	
	public function addAnimation(name:String, id:String):Void 
	{
		_animations[name] = id;
	}

	public function setAnimation(name:String):Void 
	{
		if (animation == name) return;
		
		while (_content.numChildren > 0)
		{
			_content.removeChildAt(0);
		}
		
		_sprite = new GSpriteAux(_animations[name]);
		_sprite.onEndAnimation = onEndAnimation;
		
		_content.addChild(_sprite.canvas);
		
		animation = name;
		
		update();
	}
	
	public function onEndAnimation():Void 
	{
		
	}
	
	override public function update():Void 
	{
		if (_sprite != null) _sprite.update();
		super.update();
	}
	
	override public function destroy():Void 
	{
		_sprite.destroy();
		super.destroy();
		//_animations = null;
	}
}

class GSpriteAux extends GEntity
{
	var _spriteFrames:Array<BitmapData>;
	var _skinBitmap:Bitmap;
	var _totalFrames:Int;
	var _id:String;
	
	public var currentFrame:Int = 0;
	public var onEndAnimation:Dynamic = null;
	
	public function new(id:String) 
	{
		super();
		
		_id = id;
		GImageManager.setSpriteFrames(id);
		_totalFrames = GImageManager.spriteFrames.get(id).length;
		
		_skinBitmap = new Bitmap();
		_skinBitmap.smoothing = true;
		canvas.addChild(_skinBitmap);
	}
	
	override public function update():Void
	{
		_skinBitmap.bitmapData = GImageManager.spriteFrames.get(_id)[currentFrame];
		
		currentFrame++;
		
		if (currentFrame >= _totalFrames)
		{
			currentFrame = 0;
			if (onEndAnimation != null) onEndAnimation();
		}
		
		super.update();
	}
	
	override public function destroy():Void 
	{
		_spriteFrames = null;
		_skinBitmap = null;
		
		super.destroy();
	}
}