package glue.scene;

import glue.GlueContext;
import glue.assets.GAssetRequest;
import glue.assets.GLoader;
import glue.display.GEntity;
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
			throw "Already exists a layer whit the name: " + layerName;
		}
	}

	public function add(entity:GEntity, layerName:String = "default"):Void
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
	}

	public function remove(entity:GEntity):Void
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
		mask.graphics.beginFill(0xFF0000, 0.3);
		mask.graphics.drawRect(0, 0, context.width, context.height);
		mask.graphics.endFill();
		mask.x = 0;
		mask.y = 0;
		mask.mouseEnabled = false;
		mask.doubleClickEnabled = false;
	}
}
