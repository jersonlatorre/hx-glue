package glue.scene;

import glue.assets.GLoader;
import glue.display.GEntity;
import glue.scene.GCamera;
import glue.utils.GTools;
import motion.Actuate;
import motion.easing.Quad;
import openfl.display.Sprite;
import openfl.display.Shape;

/**
 * ...
 * @author Jerson La Torre
 */

class GScene 
{
	var _canvas:Sprite;
	var _sceneCanvas:Sprite;
	var _effectCanvas:Sprite;
	var _layers:Map<String, Sprite> = new Map<String, Sprite>();
	var _entities:Array<GEntity> = new Array<GEntity>();
	var _mask:Sprite;
	
	public var camera:GCamera;
	
	public function preInit()
	{
		if (Glue.isDebug) haxe.Log.trace('[ Scene: ${ GTools.getClassName(this) } ]', null);

		_canvas = new Sprite();
		GSceneManager.canvas.addChild(_canvas);
		
		_sceneCanvas = new Sprite();
		_canvas.addChild(_sceneCanvas);
		
		_effectCanvas = new Sprite();
		_canvas.addChild(_effectCanvas);
		
		addLayer("default");

		Glue.stage.focus = _sceneCanvas;
		
		camera = new GCamera();
		
		if (usesMask())
		{
			_mask = new Sprite();
			_canvas.addChild(_mask);
			updateMask();
			_canvas.mask = _mask;
		}

		preload();
		GLoader.startDownload(init);
	}

	public function gotoScene(sceneClass:Class<GScene>)
	{
		GSceneManager.gotoScene(sceneClass);
	}

	public var load = Glue.load;

	public function preload() { }

	public function init() {	}

	public function update() { }
	
	public function addLayer(layerName:String)
	{
		if (!_layers.exists(layerName))
		{
			var layer:Sprite = new Sprite();
			_sceneCanvas.addChild(layer);
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
	
	@:allow(glue.scene.GSceneManager)
	function preUpdate()
	{
		if (!GLoader.isDownloading)
		{
			update();
		}

		// camera
		camera.update();
		
		// canvas
		_sceneCanvas.x = -camera.position.x + Glue.width / 2;
		_sceneCanvas.y = -camera.position.y + Glue.height / 2;
		
		// world coordinates
		//mouseX = GMouse.position.x / GEngine.stage.scaleX - _sceneCanvas.x;
		//mouseY = GMouse.position.y / GEngine.stage.scaleY - _sceneCanvas.y;
		
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
	
	public function fadeIn(duration:Float = 0.3)
	{
		var fade:Shape = new Shape();
		fade.graphics.beginFill(0);
		fade.graphics.drawRect(0, 0, Glue.width, Glue.height);
		fade.graphics.endFill();
		
		fade.x = 0;
		fade.y = 0;
		
		_effectCanvas.addChild(fade);
		
		Actuate.tween(fade, duration, { alpha: 0 } ).ease(Quad.easeInOut).onComplete(function()
		{
			_effectCanvas.removeChild(fade);
		});
	}

	public function fadeOut(duration:Float = 0.3, callback:Dynamic)
	{
		var fade:Shape = new Shape();
		fade.graphics.beginFill(0);
		fade.graphics.drawRect(0, 0, Glue.width, Glue.height);
		fade.graphics.endFill();

		fade.alpha = 0;
		fade.x = 0;
		fade.y = 0;
		
		_effectCanvas.addChild(fade);
		
		Actuate.tween(fade, duration, { alpha: 1 } ).ease(Quad.easeInOut).onComplete(function()
		{
			_effectCanvas.removeChild(fade);
			callback();
		});
	}

	public function destroy()
	{
		if (_canvas != null)
		{
			_canvas.mask = null;
		}

		if (_mask != null && _mask.parent == _canvas)
		{
			_canvas.removeChild(_mask);
			_mask = null;
		}

		while (_sceneCanvas.numChildren > 0)
		{
			_sceneCanvas.removeChildAt(0);
		}

		GSceneManager.canvas.removeChild(_canvas);
		
		while (_entities.length > 0)
		{
			_entities[0].destroy();
			_entities[0] = null;
			_entities.splice(0, 1);
		}
	}

	public function onResize():Void
	{
		updateMask();
	}

	function usesMask():Bool
	{
		return true;
	}

	function updateMask():Void
	{
		if (_mask == null) return;

		_mask.graphics.clear();
		_mask.graphics.beginFill(0xFF0000, 0.3);
		_mask.graphics.drawRect(0, 0, Glue.width, Glue.height);
		_mask.graphics.endFill();
		_mask.x = 0;
		_mask.y = 0;
		_mask.mouseEnabled = false;
		_mask.doubleClickEnabled = false;
	}
}
