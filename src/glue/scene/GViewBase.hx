package glue.scene;

import glue.GlueContext;
import glue.assets.GAssetRequest;
import glue.assets.GLoader;
import glue.display.GEntity;
import glue.math.GConstants;
import openfl.display.Sprite;

class GViewBase
{
	public final context:GlueContext;
	@:allow(glue.scene)
	var canvas:Sprite;
	var layerRoot:Sprite;
	var mask:Sprite;
	var layers:Map<String, Sprite> = new Map();
	var entities:Array<GEntity> = [];

	public function new(context:GlueContext)
	{
		this.context = context;
	}

	function queueAssetRequests():Void
	{
		for (request in assetRequests())
		{
			GLoader.queue(request);
		}
	}

	public function assetRequests():Array<GAssetRequest>
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

	public function add(entity:GEntity, layerName:String = "default"):GEntity
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

	public function remove(entity:GEntity):GEntity
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

	// Utility to find entity by predicate
	public function find(predicate:GEntity->Bool):Null<GEntity>
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

	// Utility to filter entities
	public function filter(predicate:GEntity->Bool):Array<GEntity>
	{
		return entities.filter(predicate);
	}

	// Utility to iterate all entities
	public function forEach(callback:GEntity->Void):Void
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
		mask.graphics.beginFill(GConstants.COLOR_DEBUG_RED, GConstants.ALPHA_DEBUG_OVERLAY);
		mask.graphics.drawRect(0, 0, context.width, context.height);
		mask.graphics.endFill();
		mask.x = 0;
		mask.y = 0;
		mask.mouseEnabled = false;
		mask.doubleClickEnabled = false;
	}
}
