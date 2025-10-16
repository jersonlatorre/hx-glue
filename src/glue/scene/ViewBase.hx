package glue.scene;

import glue.GlueContext;
import glue.assets.AssetRequest;
import glue.assets.Loader;
import glue.display.Entity;
import glue.math.Constants;
import openfl.display.Sprite;

class ViewBase
{
	public final context:GlueContext;
	@:allow(glue.scene)
	var canvas:Sprite;
	var layerRoot:Sprite;
	var mask:Sprite;
	var layers:Map<String, Sprite> = new Map();
	var entities:Array<Entity> = [];

	public function new(context:GlueContext)
	{
		this.context = context;
	}

	function queueAssetRequests():Void
	{
		for (request in assetRequests())
		{
			Loader.queue(request);
		}
	}

	public function assetRequests():Array<AssetRequest>
	{
		return [];
	}

	public function addLayer(layerName:String):Void
	{
		if (!layers.exists(layerName))
		{
			var layer = new Sprite();
			layerRoot.addChild(layer);
			layers.set(layerName, layer);
		}
		else
		{
			throw "Already exists a layer with the name: " + layerName;
		}
	}

	public function add(entity:Entity, layerName:String = "default"):Entity
	{
		if (layers.exists(layerName))
		{
			entities.push(entity);
			entity.addToLayer(layers.get(layerName));
		}
		else
		{
			throw "There is no any layer with the name: " + layerName;
		}
		return entity;
	}

	public function remove(entity:Entity):Entity
	{
		var index = entities.indexOf(entity);
		if (index >= 0)
		{
			for (layerName in layers.keys())
			{
				var layer = layers.get(layerName);
				if (entity.isChildOfLayer(layer))
				{
					entity.removeFromLayer(layer);
					break;
				}
			}
			entities.splice(index, 1);
		}
		return entity;
	}

	public function find(predicate:Entity->Bool):Null<Entity>
	{
		for (entity in entities)
		{
			if (predicate(entity))
			{
				return entity;
			}
		}
		return null;
	}

	public function filter(predicate:Entity->Bool):Array<Entity>
	{
		return entities.filter(predicate);
	}

	public function forEach(callback:Entity->Void):Void
	{
		for (entity in entities)
		{
			callback(entity);
		}
	}

	function updateEntities():Void
	{
		var i = 0;
		while (i < entities.length)
		{
			var entity = entities[i];
			if (entity.isDestroyed)
			{
				for (layerName in layers.keys())
				{
					var layer = layers.get(layerName);
					if (entity.isChildOfLayer(layer))
					{
						entity.removeFromLayer(layer);
						break;
					}
				}
				entities.splice(i, 1);
			}
			else
			{
				entity.preUpdate();
				i++;
			}
		}
	}

	function destroyEntities():Void
	{
		while (entities.length > 0)
		{
			var entity = entities.shift();
			if (entity != null)
			{
				for (layerName in layers.keys())
				{
					var layer = layers.get(layerName);
					if (entity.isChildOfLayer(layer))
					{
						entity.removeFromLayer(layer);
						break;
					}
				}
				entity.destroy();
			}
		}
	}

	function ensureMask():Void
	{
		if (mask == null)
		{
			mask = new Sprite();
			canvas.addChild(mask);
		}
		updateMask();
		canvas.mask = mask;
	}

	function clearMask():Void
	{
		if (mask != null)
		{
			mask.graphics.clear();
			if (mask.parent == canvas)
			{
				canvas.removeChild(mask);
			}
			mask = null;
		}
		if (canvas != null)
		{
			canvas.mask = null;
		}
	}

	function updateMask():Void
	{
		if (mask == null) return;
		mask.graphics.clear();
		mask.graphics.beginFill(Constants.COLOR_DEBUG_RED, Constants.ALPHA_DEBUG_OVERLAY);
		mask.graphics.drawRect(0, 0, context.width, context.height);
		mask.graphics.endFill();
		mask.x = 0;
		mask.y = 0;
		mask.mouseEnabled = false;
		mask.doubleClickEnabled = false;
	}
}
