package glue.display;

import glue.scene.GScene;
import glue.scene.GSceneManager;
import glue.math.GMath;
import glue.math.GVector2D;
import glue.utils.GTime;
import glue.assets.GSound;
import openfl.display.Sprite;
import openfl.display.Shape;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GEntity
{
	var _canvas:Sprite;
	var _skin:Sprite;
	var _anchor:GVector2D;

	var _scaleX:Float;
	var _scaleY:Float;
	var _rotation:Float;
	var _alpha:Float;

	public var width:Float = 0;
	public var height:Float = 0;

	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate)
	var isDestroyed:Bool = false;
	
	public var position:GVector2D;
	public var velocity:GVector2D;
	public var acceleration:GVector2D;
	
	public function new():Void
	{
		_skin = new Sprite();
		_canvas = new Sprite();
		_canvas.addChild(_skin);
		_anchor = new GVector2D(0, 0);

		position = new GVector2D(0, 0);
		velocity = new GVector2D(0, 0);
		acceleration = new GVector2D(0, 0);

		_scaleX = _scaleY = _alpha = 1;
		_rotation = 0;

		init();
	}

	public function init() { }

	public function createRectangleShape(width:Float, height:Float, color:UInt = 0x000000)
	{
		this.width = width;
		this.height = height;

		var graphic = new Shape();
		graphic.graphics.beginFill(color);
		graphic.graphics.drawRect(0, 0, width, height);
		graphic.graphics.endFill();

		_skin.addChild(graphic);
	}

	public function createCircleShape(radius:Float, color:UInt = 0x000000)
	{
		this.width = this.height = 2 * radius;

		var graphic = new Shape();
		graphic.graphics.beginFill(color);
		graphic.graphics.drawCircle(radius, radius, radius);
		graphic.graphics.endFill();

		_skin.addChild(graphic);
	}

	function removeGraphics()
	{
		_skin.graphics.clear();
	}
	
	public function setPosition(x:Float, y:Float)
	{
		position.x = x;
		position.y = y;
		_canvas.x = Std.int(position.x);
		_canvas.y = Std.int(position.y);
	}
	
	public function setPositionX(x:Float)
	{
		position.x = x;
	}
	
	public function setPositionY(y:Float)
	{
		position.y = y;
	}
	
	public function setScale(scaleX:Float, scaleY:Float)
	{
		_scaleX = scaleX;
		_scaleY = scaleY;
		_canvas.scaleX = scaleX;
		_canvas.scaleY = scaleY;
		_canvas.width = Std.int(_canvas.width) * GMath.sign(scaleX);
		_canvas.height = Std.int(_canvas.height) * GMath.sign(scaleY);
	}
	
	public function setScaleX(value:Float)
	{
		_scaleX = value;
		_canvas.scaleX = value;
		_canvas.width = Std.int(_canvas.width) * GMath.sign(value);
	}

	public function getScaleX():Float
	{
		return _scaleX;
	}
	
	public function setScaleY(value:Float)
	{
		_scaleY = value;
		_canvas.scaleY = value;
		_canvas.height = Std.int(_canvas.height) * GMath.sign(value);
	}

	public function getScaleY():Float
	{
		return _scaleY;
	}

	public function setRotation(value:Float)
	{
		_rotation = value;
		_canvas.rotation = (57.29578) * value;
	}

	public function getRotation():Float
	{
		return _rotation;
	}
	
	public function setAnchor(x:Float, y:Float)
	{
		_anchor.x = x;
		_anchor.y = y;
		_skin.x = -width * _anchor.x;
		_skin.y = -height * _anchor.y;
	}
	
	public function setAlpha(value:Float)
	{
		_alpha = value;
		_skin.alpha = value;
	}

	public function getAlpha():Float
	{
		return _alpha;
	}

	public function gotoScene(screenClass:Dynamic)
	{
		GSceneManager.gotoScene(screenClass);
	}

	@:allow(glue.scene.GScene.add, glue.scene.GPopup.add, glue.data.GLoader.onDownloadFileComplete, glue.utils.GStats)
	function addToLayer(layer:Sprite):Dynamic
	{
		layer.addChild(_canvas);
		return this;
	}
	
	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.scene.GScene.remove, glue.scene.GPopup.remove)
	function removeFromLayer(layer:Sprite):Dynamic
	{
		layer.removeChild(_canvas);
		return this;
	}
	
	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.scene.GScene.remove, glue.scene.GPopup.remove)
	function isChildOfLayer(layer:Sprite):Bool
	{
		return layer.contains(_canvas);
	}
	
	public function update() { }

	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.utils.GStats)
	function preUpdate():Void 
	{
		_canvas.x = Std.int(position.x);
		_canvas.y = Std.int(position.y);
		
		velocity += acceleration * GTime.deltaTime;
		position += velocity * GTime.deltaTime;
		
		update();
	}
	
	public function destroy()
	{
		_canvas.removeChild(_skin);
		_canvas = null;
		_skin = null;
		isDestroyed = true;
	}
}