package glue.display;

import glue.ui.GScene;
import glue.utils.GMath;
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

	@:allow(glue.ui.GScene.preUpdate)
	var isDestroyed:Bool = false;
	
	public var position:GVector2D;
	
	public function new():Void
	{
		_canvas = new Sprite();
		_skin = new Sprite();
		_canvas.addChild(_skin);
		position = new GVector2D(0, 0);
		_anchor = new GVector2D(0, 0);

		init();
	}

	public function init() { }

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
		_canvas.scaleX = scaleX;
		_canvas.scaleY = scaleY;
		_canvas.width = Std.int(_canvas.width) * GMath.sign(scaleX);
		_canvas.height = Std.int(_canvas.height) * GMath.sign(scaleY);
		return this;
	}
	
	public function setScaleX(scaleX:Float):Dynamic
	{
		_scaleX = scaleX;
		_canvas.scaleX = scaleX;
		_canvas.width = Std.int(_canvas.width) * GMath.sign(scaleX);
		return this;
	}
	
	public function setScaleY(scaleY:Float):Dynamic
	{
		_scaleY = scaleY;
		_canvas.scaleY = scaleY;
		_canvas.height = Std.int(_canvas.height) * GMath.sign(scaleY);
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

	@:allow(glue.ui.GScene.addEntity, glue.data.GLoader.onDownloadFileComplete)
	function addToLayer(layer:Sprite):Dynamic
	{
		layer.addChild(_canvas);
		return this;
	}
	
	@:allow(glue.ui.GScene.preUpdate, glue.ui.GScene.removeEntity)
	function removeFromLayer(layer:Sprite):Dynamic
	{
		layer.removeChild(_canvas);
		return this;
	}
	
	@:allow(glue.ui.GScene.preUpdate, glue.ui.GScene.removeEntity)
	function isChildOfLayer(layer:Sprite):Bool
	{
		return layer.contains(_canvas);
	}
	
	public function update():Void { }

	@:allow(glue.ui.GScene.preUpdate)
	function preUpdate():Void 
	{
		_canvas.x = Std.int(position.x);
		_canvas.y = Std.int(position.y);
		update();
	}
	
	public function destroy():Void
	{
		isDestroyed = true;
	}
}