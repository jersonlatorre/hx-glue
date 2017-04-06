package glue.display;

import glue.ui.GScene;
import glue.utils.GVector2D;
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
	
	public var position:GVector2D;
	
	public function new():Void
	{
		_canvas = new Sprite();
		_skin = new Sprite();
		_canvas.addChild(_skin);
		position = new GVector2D(0, 0);
		_anchor = new GVector2D(0, 0);
	}

	public function addTo(scene:GScene, ?layer:String):Dynamic
	{
		scene.addEntity(this, layer);
		return this;
	}
	
	public function setPosition(x:Float, y:Float):Dynamic
	{
		position.x = x;
		position.y = y;
		return this;
	}
	
	public function setPositionX(x:Float):Dynamic
	{
		position.x = x;
		return this;
	}
	
	public function setPositionY(y:Float):Dynamic
	{
		position.y = y;
		return this;
	}
	
	public function setScale(scaleX:Float, scaleY:Float):Dynamic
	{
		_scaleX = scaleX;
		_scaleY = scaleY;
		return this;
	}
	
	public function setScaleX(scaleX:Float):Dynamic
	{
		_scaleX = scaleX;
		return this;
	}
	
	public function setScaleY(scaleY:Float):Dynamic
	{
		_scaleY = scaleY;
		return this;
	}
	
	public function setAnchor(x:Float, y:Float):Dynamic
	{
		_anchor.x = x;
		_anchor.y = y;
		_skin.x = -width * _anchor.x;
		_skin.y = -height * _anchor.y;
		return this;
	}
	
	public function setAlpha(alpha:Float):Dynamic
	{
		this._skin.alpha = alpha;
		this._alpha = alpha;
		return this;
	}
	
	public function addToLayer(layer:Sprite):Dynamic
	{
		layer.addChild(_canvas);
		return this;
	}
	
	public function removeFromLayer(layer:Sprite):Dynamic
	{
		layer.removeChild(_canvas);
		return this;
	}
	
	public function isChildOfLayer(layer:Sprite):Bool
	{
		return layer.contains(_canvas);
	}
	
	public function update():Void 
	{
		_canvas.x = position.x;
		_canvas.y = position.y;
		_canvas.scaleX = _scaleX;
		_canvas.scaleY = _scaleY;
		_canvas.alpha = _alpha;
	}
	
	public function destroy():Void
	{
		isDestroyed = true;
	}
}