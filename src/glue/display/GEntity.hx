package glue.display;

import glue.Glue;
import glue.math.GConstants;
import glue.scene.GScene;
import glue.scene.GSceneManager;
import glue.math.GVector2D;
import glue.utils.GTime;
import glue.input.GInput;
import glue.input.InputActions;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * Base entity class for all game objects
 * Handles rendering, physics, and lifecycle management
 * @author Jerson La Torre
 */

class GEntity
{
	var _canvas:Sprite;
	var _skin:Sprite;
	var _debug:Sprite;
	var _parent:Sprite;
	var _layers:Map<String, Sprite> = new Map<String, Sprite>();
	var _entities:Array<GEntity> = new Array<GEntity>();

	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.scene.GViewBase)
	var isDestroyed:Bool = false;
	public var destroyed(get, never):Bool;
	
	public var position:GVector2D;
	public var velocity:GVector2D;
	public var acceleration:GVector2D;
	public var scale:GVector2D;
	public var rotation:Float;
	public var width:Float = 0;
	public var height:Float = 0;
	public var alpha:Float;
	public var anchor:GVector2D;
	public var bounds:Rectangle = new Rectangle();
	
	public function new():Void
	{
		_skin = new Sprite();
		_debug = new Sprite();
		_canvas = new Sprite();
		_canvas.addChild(_skin);
		_canvas.addChild(_debug);

		position = new GVector2D(0, 0);
		velocity = new GVector2D(0, 0);
		acceleration = new GVector2D(0, 0);

		anchor = new GVector2D(0, 0);
		scale = new GVector2D(1, 1);
		alpha = 1;
		rotation = 0;

		addLayer("default");

		init();
	}

	public function init() { }

	public function gotoScene(sceneClass:Class<GScene>)
	{
		GSceneManager.gotoScene(sceneClass);
	}

	public function addLayer(layerName:String)
	{
		if (!_layers.exists(layerName))
		{
			var layer:Sprite = new Sprite();
			_canvas.addChild(layer);
			_layers.set(layerName, layer);
		}
		else
		{
			throw "Already exists a layer with the name: " + layerName;
		}
	}

	public function add(entity:GEntity, layerName:String = "default"):GEntity
	{
		if (_layers.exists(layerName))
		{
			_entities.push(entity);
			entity.addToLayer(_layers.get(layerName));
		}
		else
		{
			throw "There is no any layer with the name: " + layerName;
		}
		return entity;
	}

	public function remove(entity:GEntity):GEntity
	{
		var index = _entities.indexOf(entity);

		if (index >= 0)
		{
			for (layerName in _layers.keys())
			{
				if (entity.isChildOfLayer(_layers.get(layerName)))
				{
					entity.removeFromLayer(_layers.get(layerName));
					break;
				}
			}

			_entities.splice(index, 1);
		}
		return entity;
	}

	public function at(x:Float, y:Float):GEntity
	{
		position.set(x, y);
		return this;
	}

	public function withVelocity(vx:Float, vy:Float):GEntity
	{
		velocity.set(vx, vy);
		return this;
	}

	public function withScale(sx:Float, sy:Float):GEntity
	{
		scale.set(sx, sy);
		return this;
	}

	public function withAnchor(ax:Float, ay:Float):GEntity
	{
		anchor.set(ax, ay);
		return this;
	}

	public function withRotation(rot:Float):GEntity
	{
		rotation = rot;
		return this;
	}

	public function withAlpha(a:Float):GEntity
	{
		alpha = a;
		return this;
	}

	public inline function isPressed(action:String):Bool
	{
		return GInput.isKeyPressed(action);
	}

	public inline function isDown(action:String):Bool
	{
		return GInput.isKeyDown(action);
	}

	public inline function isUp(action:String):Bool
	{
		return GInput.isKeyUp(action);
	}

	public inline function getDirection(left:String = "left", right:String = "right", up:String = "up", down:String = "down"):GVector2D
	{
		return InputActions.getDirection(left, right, up, down);
	}

	public inline function getHorizontal(left:String = "left", right:String = "right"):Float
	{
		return InputActions.getHorizontal(left, right);
	}

	public inline function getVertical(up:String = "up", down:String = "down"):Float
	{
		return InputActions.getVertical(up, down);
	}

		@:allow(glue.scene.GScene.add, glue.scene.GPopup.add, glue.scene.GViewBase, glue.assets.GLoader, glue.utils.GStats)
		function addToLayer(layer:Sprite):GEntity
	{
		_parent = layer;
		layer.addChild(_canvas);
		return this;
	}

		@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.scene.GScene.remove, glue.scene.GPopup.remove, glue.scene.GViewBase)
		function removeFromLayer(layer:Sprite):GEntity
	{
		layer.removeChild(_canvas);
		return this;
	}
	
		@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.scene.GScene.remove, glue.scene.GPopup.remove, glue.scene.GViewBase)
		function isChildOfLayer(layer:Sprite):Bool
	{
		return layer.contains(_canvas);
	}
	
	public function update() { }

	function get_destroyed():Bool
	{
		return isDestroyed;
	}

	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate, glue.scene.GViewBase, glue.utils.GStats)
	function preUpdate():Void 
	{
		if (_canvas == null) return; 
		_canvas.x = Std.int(position.x);
		_canvas.y = Std.int(position.y);
		_canvas.scaleX = scale.x;
		_canvas.scaleY = scale.y;
		_canvas.rotation = GConstants.RAD_TO_DEG * rotation;
		_canvas.alpha = alpha;
		
		_skin.x = -width * anchor.x;
		_skin.y = -height * anchor.y;

		velocity += acceleration * GTime.deltaTime;
		position += velocity * GTime.deltaTime;

		if (Glue.showBounds)
		{
			_debug.graphics.clear();
			_debug.graphics.lineStyle(1, GConstants.COLOR_DEBUG_RED);
			_debug.graphics.drawRect(-width * anchor.x, -height * anchor.y, width, height);

			_debug.graphics.beginFill(GConstants.COLOR_DEBUG_RED);
			_debug.graphics.drawCircle(0, 0, 5);
			_debug.graphics.endFill();

			_debug.graphics.lineStyle(1, GConstants.COLOR_DEBUG_GREEN);
			_debug.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
		}

		var i:Int = 0;
		
		while (i < _entities.length)
		{
			var entity = _entities[i];
			
			if (entity.isDestroyed)
			{
				for (layerName in _layers.keys())
				{
					if (entity.isChildOfLayer(_layers.get(layerName)))
					{
						entity.removeFromLayer(_layers.get(layerName));
						break;
					}
				}
				
				_entities.splice(i, 1);
			}
			else
			{
				entity.preUpdate();
				i++;
			}
		}
		
		update();
	}

	public function collideWith(entity:GEntity):Bool
	{
		return !(entity.position.x + entity.bounds.x > position.x + bounds.x + bounds.width 
			  || entity.position.x + entity.bounds.x + entity.bounds.width < position.x + bounds.x 
			  || entity.position.y + entity.bounds.y > position.y + bounds.y + bounds.height
			  || entity.position.y + entity.bounds.y + entity.bounds.height < position.y + bounds.y);
	}
	
	public function destroy()
	{
		if (_canvas != null)
		{
			_canvas.removeChild(_skin);
			_canvas = null;
		}
		
		_skin = null;
		isDestroyed = true;
	}
}
