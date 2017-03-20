package com.glue;

import haxe.Json;
import openfl.net.URLRequest;
import openfl.net.URLLoader;
import com.glue.data.GLoader;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GSceneManager;
import com.glue.utils.GTime;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import com.glue.ui.GPreloader;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GEngine
{
	static public var stage:Stage;
	static public var mainScene:Dynamic;
	static public var customPreloader:Dynamic;
	static public var width:Int;
	static public var height:Int;
	static public var canvas:Sprite;
	static var loader:URLLoader;
	
	static public function start(data:Dynamic)
	{
		GEngine.stage = data.stage;
		GEngine.width = data.width;
		GEngine.height = data.height;
		GEngine.mainScene = data.mainScene;

		loader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, onAssetsManifestComplete);
		loader.load(new URLRequest(data.assets));

		// trace("holaaaaaaaaa: " + data.assets);
		// var assets:Dynamic = Json.parse(data.assets);
		// trace("holaaaaaaaaa: ", assets);
	}

	static function onAssetsManifestComplete(e:Event)
	{
		var assets:Array<Dynamic> = Json.parse(loader.data);
		
		for (asset in assets)
		{
			GLoader.queue(asset);
		}

		GEngine.stage.addEventListener(Event.ENTER_FRAME, onUpdate);

		canvas = new Sprite();
		GEngine.stage.addChild(canvas);
		
		GTime.init();
		GMouse.init();
		GKeyboard.init();
		GSceneManager.init();
		
		if (customPreloader != null)
		{
			GSceneManager.gotoScene(customPreloader);
		}
		else
		{
			GSceneManager.gotoScene(GPreloader);
		}
		
		GLoader.load(onAssetsDownloaded);
	}
	
	static function onAssetsDownloaded() 
	{
		GSceneManager.gotoScene(GEngine.mainScene);
	}
	
	static public function onUpdate(e:Event):Void
	{
		GMouse.update();
		GSceneManager.update();
		GMouse.clear();
		GTime.update();
	}
	
	static public function setScale(x:Float, y:Float)
	{
		canvas.scaleX = x;
		canvas.scaleY = y;
	}
}