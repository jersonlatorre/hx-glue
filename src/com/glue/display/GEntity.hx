package com.glue.display;
import com.glue.utils.GRectBounds;
import com.glue.utils.GVector2D;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author uno
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
	private var _width:Float = 0;
	private var _height:Float = 0;
	public var isDestroyed:Bool = false;
	
	public var position:GVector2D;
	
	public function new():Void
	{
		_canvas = new Sprite();
		_skin = new Sprite();
		_canvas.addChild(_skin);
		position = new GVector2D(0, 0);
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
		_skin.x = -_width * _anchor.x;
		_skin.y = -_height * _anchor.y;
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
	
	//public function setBounds(left:Float, top:Float, w:Float, h:Float):Void 
	//{
		//bounds = new GRectBounds(left, top, w, h);
	//}
	
	public function update():Void 
	{
		_canvas.x = position.x;
		_canvas.y = position.y;
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
		//while (canvas.numChildren > 0)
		//{
			//canvas.removeChildAt(0);
		//}
		//
		//canvas = null;
	}
}