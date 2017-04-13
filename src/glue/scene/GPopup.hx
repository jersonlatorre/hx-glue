package glue.scene;

import openfl.display.Sprite;
import glue.display.GEntity;
import glue.utils.GTools;
import glue.assets.GLoader;

/**
 * ...
 * @author Jerson La Torre
 */

class GPopup 
{	
	var _canvas:Sprite;
	var _popupCanvas:Sprite;
	var _layers:Map<String, Sprite> = new Map<String, Sprite>();
	var _entities:Array<GEntity> = new Array<GEntity>();
	var _mask:Sprite;
	
	public function preInit()
	{
		trace("Popup: " + GTools.getClassName(this));

		_canvas = new Sprite();
		GSceneManager.canvas.addChild(_canvas);
		
		_popupCanvas = new Sprite();
		_canvas.addChild(_popupCanvas);
		
		_mask = new Sprite();
		_canvas.addChild(_mask);
		
		addLayer("default");

		Glue.stage.focus = _popupCanvas;
		
		// mask
		_mask.graphics.beginFill(0xFF0000, 0.3);
		_mask.graphics.drawRect(0, 0, Glue.width, Glue.height);
		_mask.graphics.endFill();
		_mask.x = 0;
		_mask.y = 0;
		_mask.mouseEnabled = false;
		_mask.doubleClickEnabled = false;
		_canvas.mask = _mask;

		init();
	}

	public function gotoScene(screenClass:Dynamic)
	{
		GSceneManager.gotoScene(screenClass);
	}

	public function init() {	}

	public function update() { }
	
	public function addLayer(layerName:String)
	{
		if (!_layers.exists(layerName))
		{
			var layer:Sprite = new Sprite();
			_popupCanvas.addChild(layer);
			_layers.set(layerName, layer);
		}
		else
		{
			throw "Already exists a layer whit the name: " + layerName;
		}
	}
	
	public function addEntity(entity:GEntity, layerName:String = "default")
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
	
	public function removeEntity(entity:GEntity) 
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
	
	@:allow(glue.scene.GSceneManager)
	function preUpdate()
	{
		update();

		// entities
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
	}
	
	public function destroy()
	{
		while (_popupCanvas.numChildren > 0)
		{
			_popupCanvas.removeChildAt(0);
		}

		GSceneManager.canvas.removeChild(_canvas);
		
		while (_entities.length > 0)
		{
			_entities[0].destroy();
			_entities[0] = null;
			_entities.splice(0, 1);
		}
	}
}