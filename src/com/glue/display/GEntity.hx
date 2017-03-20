package com.glue.display;

import com.glue.utils.GVector2D;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

@final class GEntity
{
	private var _canvas:Sprite;
	private var _skin:Sprite;
	private var _anchor:GVector2D;
	private var _scaleX:Float = 1;
	private var _scaleY:Float = 1;
	private var _alpha:Float = 1;
	public var width:Float = 0;
	public var height:Float = 0;
	public var isDestroyed:Bool = false;
	
	var isPhysics:Bool = false;

	public var position:GVector2D;
	public var velocity:GVector2D;
	public var acceleration:GVector2D;
	
	public function new():Void
	{
		_canvas = new Sprite();
		_skin = new Sprite();
		_canvas.addChild(_skin);
		position = new GVector2D(0, 0);
		velocity = new GVector2D(0, 0);
		acceleration = new GVector2D(0, 0);
		_anchor = new GVector2D(0, 0);
	}
	
	public function setPosition(x:Float, y:Float):GEntity
	{
		position.x = x;
		position.y = y;
		return this;
	}
	
	public function setPositionX(x:Float):GEntity
	{
		position.x = x;
		return this;
	}
	
	public function setPositionY(y:Float):GEntity
	{
		position.y = y;
		return this;
	}
	
	public function setScale(scaleX:Float, scaleY:Float):GEntity
	{
		_scaleX = scaleX;
		_scaleY = scaleY;
		return this;
	}
	
	public function setScaleX(scaleX:Float):GEntity
	{
		_scaleX = scaleX;
		return this;
	}
	
	public function setScaleY(scaleY:Float):GEntity
	{
		_scaleY = scaleY;
		return this;
	}
	
	public function setAnchor(x:Float, y:Float):GEntity
	{
		_anchor.x = x;
		_anchor.y = y;
		_skin.x = -width * _anchor.x;
		_skin.y = -height * _anchor.y;
		return this;
	}
	
	public function setAlpha(alpha:Float):GEntity
	{
		this._alpha = alpha;
		return this;
	}
	
	public function addToLayer(layer:Sprite):GEntity
	{
		layer.addChild(_canvas);
		return this;
	}
	
	public function removeFromLayer(layer:Sprite):GEntity
	{
		layer.removeChild(_canvas);
		return this;
	}
	
	public function isChildOfLayer(layer:Sprite):Bool
	{
		return layer.contains(_canvas);
	}
	
	public function setBounds(left:Float, top:Float, w:Float, h:Float):Void 
	{
		isPhysics = true;
	}
	
	public function update():Void 
	{
		if (isPhysics)
		{
			_canvas.x = position.x;
			_canvas.y = position.y;
		}
		else
		{
			_canvas.x = position.x;
			_canvas.y = position.y;
		}
		
		_canvas.scaleX = _scaleX;
		_canvas.scaleY = _scaleY;
		_canvas.alpha = _alpha;
	}
	
	//public function collide(entity:GEntity) 
	//{
		//if (position.x + bounds.left > entity.position.x + entity.bounds.right)
		//{
			//return false;
		//}
		//if (position.x + bounds.right < entity.position.x + entity.bounds.left)
		//{
			//return false;
		//}
		//if (position.y + bounds.top < entity.position.y + entity.bounds.bottom)
		//{
			//return false;
		//}
		//if (position.y + bounds.bottom > entity.position.y + entity.bounds.top)
		//{
			//return false;
		//}
		//
		//return true;
	//}
	
	public function destroy():Void
	{
		isDestroyed = true;
	}
}