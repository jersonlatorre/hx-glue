package com.glue.display;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GMultipleSprite extends GEntity
{
	public var animation:String = "";
	var _onEndAnimation:Dynamic = null;
	
	var _animations:Map<String, Dynamic> = new Map<String, Dynamic>();
	var _sprite:GSprite;
	
	public function new():Void
	{
		super();
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
		if (_onEndAnimation != null) _sprite.onEndAnimation(_onEndAnimation);
		
		width = _sprite.width;
		height = _sprite.height;
		setAnchor(_anchor.x, _anchor.y);
		update();
		animation = name;
	}
	
	public function onEndAnimation(callback:Dynamic):Void
	{
		_onEndAnimation = callback;
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