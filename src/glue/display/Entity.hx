package glue.display;

import glue.Glue;
import glue.math.Constants;
import glue.scene.Scene;
import glue.scene.SceneManager;
import glue.math.Vector2D;
import glue.utils.Time;
import glue.input.Input;
import glue.input.InputActions;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * Base entity class for all game objects
 * Handles rendering, physics, and lifecycle management
 * @author Jerson La Torre
 */

class Entity
{
	var _canvas:Sprite;
	var _skin:Sprite;
	var _debug:Sprite;
	var _parent:Sprite;
	var _layers:Map<String, Sprite> = new Map<String, Sprite>();
	var _entities:Array<Entity> = new Array<Entity>();

	@:allow(glue.scene.Scene.preUpdate, glue.scene.Popup.preUpdate, glue.scene.ViewBase)
	var isDestroyed:Bool = false;
	public var destroyed(get, never):Bool;
	
	public var position:Vector2D;
	public var velocity:Vector2D;
	public var acceleration:Vector2D;
	public var scale:Vector2D;
	public var rotation:Float;
	public var width:Float = 0;
	public var height:Float = 0;
	public var alpha:Float;
	public var anchor:Vector2D;
	public var bounds:Rectangle = new Rectangle();
	
	public function new():Void
	{
		_skin = new Sprite();
		_debug = new Sprite();
		_canvas = new Sprite();
		_canvas.addChild(_skin);
		_canvas.addChild(_debug);

		position = new Vector2D(0, 0);
		velocity = new Vector2D(0, 0);
		acceleration = new Vector2D(0, 0);

		anchor = new Vector2D(0, 0);
		scale = new Vector2D(1, 1);
		alpha = 1;
		rotation = 0;

		addLayer("default");

		init();
	}

	public function init() { }

	public function gotoScene(sceneClass:Class<Scene>)
	{
		SceneManager.gotoScene(sceneClass);
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

	public function add(entity:Entity, layerName:String = "default"):Entity
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

	public function remove(entity:Entity):Entity
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

	public function at(x:Float, y:Float):Entity
	{
		position.set(x, y);
		return this;
	}

	public function withVelocity(vx:Float, vy:Float):Entity
	{
		velocity.set(vx, vy);
		return this;
	}

	public function withScale(sx:Float, sy:Float):Entity
	{
		scale.set(sx, sy);
		return this;
	}

	public function withAnchor(ax:Float, ay:Float):Entity
	{
		anchor.set(ax, ay);
		return this;
	}

	public function withRotation(rot:Float):Entity
	{
		rotation = rot;
		return this;
	}

	public function withAlpha(a:Float):Entity
	{
		alpha = a;
		return this;
	}

	public inline function isPressed(action:String):Bool
	{
		return Input.isKeyPressed(action);
	}

	public inline function isDown(action:String):Bool
	{
		return Input.isKeyDown(action);
	}

	public inline function isUp(action:String):Bool
	{
		return Input.isKeyUp(action);
	}

	public inline function getDirection(left:String = "left", right:String = "right", up:String = "up", down:String = "down"):Vector2D
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

		@:allow(glue.scene.Scene.add, glue.scene.Popup.add, glue.scene.ViewBase, glue.assets.Loader, glue.utils.Stats)
		function addToLayer(layer:Sprite):Entity
	{
		_parent = layer;
		layer.addChild(_canvas);
		return this;
	}

		@:allow(glue.scene.Scene.preUpdate, glue.scene.Popup.preUpdate, glue.scene.Scene.remove, glue.scene.Popup.remove, glue.scene.ViewBase)
		function removeFromLayer(layer:Sprite):Entity
	{
		layer.removeChild(_canvas);
		return this;
	}
	
		@:allow(glue.scene.Scene.preUpdate, glue.scene.Popup.preUpdate, glue.scene.Scene.remove, glue.scene.Popup.remove, glue.scene.ViewBase)
		function isChildOfLayer(layer:Sprite):Bool
	{
		return layer.contains(_canvas);
	}
	
	public function update() { }

	function get_destroyed():Bool
	{
		return isDestroyed;
	}

	@:allow(glue.scene.Scene.preUpdate, glue.scene.Popup.preUpdate, glue.scene.ViewBase, glue.utils.Stats)
	function preUpdate():Void 
	{
		if (_canvas == null) return; 
		_canvas.x = Std.int(position.x);
		_canvas.y = Std.int(position.y);
		_canvas.scaleX = scale.x;
		_canvas.scaleY = scale.y;
		_canvas.rotation = Constants.RAD_TO_DEG * rotation;
		_canvas.alpha = alpha;
		
		_skin.x = -width * anchor.x;
		_skin.y = -height * anchor.y;

		velocity += acceleration * Time.deltaTime;
		position += velocity * Time.deltaTime;

		if (Glue.showBounds)
		{
			_debug.graphics.clear();
			_debug.graphics.lineStyle(1, Constants.COLOR_DEBUG_RED);
			_debug.graphics.drawRect(-width * anchor.x, -height * anchor.y, width, height);

			_debug.graphics.beginFill(Constants.COLOR_DEBUG_RED);
			_debug.graphics.drawCircle(0, 0, 5);
			_debug.graphics.endFill();

			_debug.graphics.lineStyle(1, Constants.COLOR_DEBUG_GREEN);
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

	public function collideWith(entity:Entity):Bool
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
