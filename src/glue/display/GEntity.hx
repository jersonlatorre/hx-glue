package glue.display;

import glue.scene.GSceneManager;
import glue.math.GVector2D;
import glue.utils.GTime;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GEntity
{
	var _canvas:Sprite;
	var _skin:Sprite;
	var _debug:Sprite;
	var _parent:Sprite;
	var _layers:Map<String, Sprite> = new Map<String, Sprite>();
	var _entities:Array<GEntity> = new Array<GEntity>();

	@:allow(glue.scene.GScene.preUpdate, glue.scene.GPopup.preUpdate)
	var isDestroyed:Bool = false;
	
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

	public function gotoScene(screenClass:Dynamic)
	{
		GSceneManager.gotoScene(screenClass);
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
			throw "Already exists a layer whit the name: " + layerName;
		}
	}

	public function add(entity:GEntity, layerName:String = "default")
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
	}

	public function remove(entity:GEntity) 
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
	}

	@:allow(glue.scene.GScene.add, glue.scene.GPopup.add, glue.data.GLoader.onDownloadFileComplete, glue.utils.GStats)
	function addToLayer(layer:Sprite):Dynamic
	{
		_parent = layer;
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
		if (_canvas == null) return; 
		_canvas.x = Std.int(position.x);
		_canvas.y = Std.int(position.y);
		_canvas.scaleX = scale.x;
		_canvas.scaleY = scale.y;
		_canvas.rotation = (57.29578) * rotation;
		_canvas.alpha = alpha;
		
		_skin.x = -width * anchor.x;
		_skin.y = -height * anchor.y;

		velocity += acceleration * GTime.deltaTime;
		position += velocity * GTime.deltaTime;

		if (Glue.showBounds)
		{
			_debug.graphics.clear();
			_debug.graphics.lineStyle(1, 0xFF0000);
			_debug.graphics.drawRect(-width * anchor.x, -height * anchor.y, width, height);
			
			_debug.graphics.beginFill(1, 0xFF0000);
			_debug.graphics.drawCircle(0, 0, 5);
			_debug.graphics.endFill();

			_debug.graphics.lineStyle(1, 0x00FF00);
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
			  || entity.position.y + entity.bounds.y > position.y + bounds.y + bounds.width
			  || entity.position.y + entity.bounds.y + entity.bounds.width < position.y + bounds.y);
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