package com.glue.ui;

import com.glue.entities.GEntity;
import com.glue.entities.GImage;
import com.glue.game.GCamera;
import com.glue.input.GMouse;
import flash.display.MovieClip;
import flash.display.Sprite;
import motion.Actuate;
import motion.easing.Quad;

/**
 * ...
 * @author uno
 */

class GScene 
{
	public var canvas:Sprite;
	
	var _entitiesCanvas:Sprite;
	var _effectCanvas:Sprite;
	var _mask:Sprite;
	
	public var camera:GCamera;
	public var mouseX:Float;
	public var mouseY:Float;
	
	var _layers:Map<String, Sprite> = new Map<String, Sprite>();
	var _entities:Array<GEntity> = new Array<GEntity>();
	
	public function new()
	{
		canvas = new Sprite();
		GSceneManager.sceneCanvas.addChild(canvas);
		
		_entitiesCanvas = new Sprite();
		canvas.addChild(_entitiesCanvas);
		
		_effectCanvas = new Sprite();
		canvas.addChild(_effectCanvas);
		
		_mask = new Sprite();
		canvas.addChild(_mask);
		
		camera = new GCamera();
		
		// mask
		
		_mask.graphics.beginFill(0xFF0000, 0.3);
		_mask.graphics.drawRect(0, 0, GEngine.width, GEngine.height);
		_mask.graphics.endFill();
		_mask.x = 0;
		_mask.y = 0;
		_mask.mouseEnabled = false;
		_mask.doubleClickEnabled = false;
		canvas.mask = _mask;
		
		addLayer("default");
	}
	
	public function addLayer(layerName:String):Void
	{
		if (!_layers.exists(layerName))
		{
			var layer:Sprite = new Sprite();
			_entitiesCanvas.addChild(layer);
			_layers.set(layerName, layer);
		}
		else
		{
			trace("Already exists a layer whit the name: " + layerName);
		}
	}
	
	public function addEntity(entity:GEntity, layerName:String = "default"):Void
	{
		if (_layers.exists(layerName))
		{
			_entities.push(entity);
			entity.addToWorldLayer(_layers.get(layerName));
			entity.layerName = layerName;
		}
		else
		{
			trace("There is no any layer with the name: " + layerName);
		}
	}
	
	public function removeEntity(entity:GEntity):Void 
	{
		var i:Int;
		
		for (i in 0..._entities.length)
		{
			if (_entities[i] == entity)
			{
				_entities.splice(i, 1);
				entity.removeFromWorldLayer(_layers.get(entity.layerName));
				entity.destroy();
				return;
			}
		}
	}
	
	public function collide(e1:GImage, e2:GImage):Bool
	{
		if (e1.position.x + e1.bounds.left > e2.position.x + e2.bounds.right ||
			e1.position.x + e1.bounds.right < e2.position.x + e2.bounds.left ||
			e1.position.y + e1.bounds.top > e2.position.y + e2.bounds.bottom ||
			e1.position.y + e2.bounds.bottom < e2.position.y + e2.bounds.top)
		{
			return false;
		}
		
		return true;
	}
	
	public function update():Void
	{
		// canvas
		
		_entitiesCanvas.x = -camera.position.x + GEngine.width / 2;
		_entitiesCanvas.y = camera.position.y +  GEngine.height / 2;
		//_entitiesCanvas.x = -camera.position.x + Lib.application.window.width / 2;
		//_entitiesCanvas.y = camera.position.y +  Lib.application.window.height / 2;
		
		// camera
		
		camera.update();
		
		// world coordinates
		
		mouseX = GMouse.position.x / GEngine.stage.scaleX - _entitiesCanvas.x;
		mouseY = GMouse.position.y / GEngine.stage.scaleY - _entitiesCanvas.y;
		
		// entities
		
		var i:Int;
		
		for (i in 0... _entities.length)
		{
			_entities[i].update();
		}
	}
	
	public function fadeIn(duration:Float = 0.5)
	{
		var fade:Sprite = new Sprite();
		fade.graphics.beginFill(0);
		fade.graphics.drawRect(0, 0, GEngine.width, GEngine.height);
		fade.graphics.endFill();
		
		fade.x = 0;
		fade.y = 0;
		
		_effectCanvas.addChild(fade);
		
		Actuate.tween(fade, duration, { alpha: 0 } ).ease(Quad.easeIn).onComplete(function()
		{
			_effectCanvas.removeChild(fade);
		});
	}
	
	public function destroy():Void
	{
		camera.destroy();
		camera = null;
		
		while (GSceneManager.sceneCanvas.numChildren > 0)
		{
			GSceneManager.sceneCanvas.removeChildAt(0);
		}
		
		while (_entitiesCanvas.numChildren > 0)
		{
			_entitiesCanvas.removeChildAt(0);
		}
		
		var i:Int = 0;
		while (_entities.length > 0)
		{
			_entities[0].destroy();
			_entities[0] = null;
			_entities.splice(0, 1);
		}
		
		_layers = null;
		_entities = null;
		camera = null;
	}
}