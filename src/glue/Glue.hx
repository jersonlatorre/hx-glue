package glue;

import glue.assets.GLoader;
import glue.scene.GPreloader;
import glue.scene.GSceneManager;
import glue.utils.GTime;
import glue.utils.GStats;
import glue.input.GInput;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

@:final class Glue
{
	static var mainScene:Dynamic;
	static var customPreloader:Dynamic;
	static var isPreloading:Bool;

	static public var stage:Stage;
	static public var width:Int;
	static public var height:Int;
	static public var canvas:Sprite;
	static public var isDebug:Bool = false;
	static public var showBounds:Bool = false;

	@:allow(glue.assets.GLoader)
	static var cacheCanvas:Sprite;

	static public function start(data:Dynamic)
	{
		Glue.stage = Lib.application.window.stage;
		Glue.width = Lib.application.window.width;
		Glue.height = Lib.application.window.height;
		
		Glue.mainScene = data.mainScene;
		Glue.isDebug = data.isDebug;
		Glue.showBounds = data.showBounds;
		customPreloader = data.preloader;
		
		canvas = new Sprite();
		Glue.stage.addChild(canvas);
		Glue.stage.addEventListener(Event.ENTER_FRAME, onUpdate);

		if (data.showStats)
		{
			var stats = new GStats();
			Glue.stage.addChild(stats);
		}
		
		GTime.init();
		GInput.init();
		GSceneManager.init();

		// if (isPreloading)
		// {
			if (customPreloader == null)
			{
				GSceneManager.showLoaderScene(GPreloader, onAssetsDownloaded);
			}
			else
			{
				GSceneManager.showLoaderScene(customPreloader, onAssetsDownloaded);
			}
		// }
		// else
		// {
		// 	GSceneManager.gotoScene(Glue.mainScene);
		// }
	}

	static function onAssetsDownloaded() 
	{
		GSceneManager.gotoScene(Glue.mainScene);
	}
	
	static function onUpdate(e:Event)
	{
		GTime.update();	
		GInput.update();
		GSceneManager.update();
		GInput.clear();
	}
	
	static public function setScale(x:Float, y:Float)
	{
		canvas.scaleX = x;
		canvas.scaleY = y;
	}
	
	static public var load =
	{
		spritesheet:
		{
			fromAdobeAnimate: function(assetId:String, url:String, fps:Int = 30)
			{
				GLoader.load({ type:"adobe_animate_spritesheet", id: assetId, url: url, fps: fps });
			}
		},
		
		image: function(assetId:String, url:String)
		{
			GLoader.load({ type: "image", id: assetId, url: url });
		},
		
		json: function(assetId:String, url:String)
		{
			GLoader.load({ type: "json", id: assetId, url: url });
		},
		
		sound: function(assetId:String, url:String, group:String = null)
		{
			GLoader.load({ type: "sound", id: assetId, url: url, group: group});
		}
	}
}