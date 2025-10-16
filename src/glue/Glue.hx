package glue;

import glue.assets.GLoader;
import glue.scene.GPreloader;
import glue.scene.GScene;
import glue.scene.GPopup;
import glue.scene.GSceneManager;
import glue.utils.GTime;
import glue.utils.GStats;
import glue.input.GInput;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

typedef GlueConfig =
{
	var mainScene:Class<GScene>;
	@:optional var preloader:Null<Class<GPopup>>;
	@:optional var isDebug:Bool;
	@:optional var showBounds:Bool;
	@:optional var showStats:Bool;
}

private typedef ResolvedGlueConfig =
{
	var mainScene:Class<GScene>;
	var preloader:Null<Class<GPopup>>;
	var isDebug:Bool;
	var showBounds:Bool;
	var showStats:Bool;
}

@:final class Glue
{
	static var mainScene:Class<GScene>;
	static var customPreloader:Null<Class<GPopup>>;
	static var isPreloading:Bool;

	static public var stage:Stage;
	static public var width:Int;
	static public var height:Int;
	static public var canvas:Sprite;
	static public var isDebug:Bool = false;
	static public var showBounds:Bool = false;

	@:allow(glue.assets.GLoader)
	static var cacheCanvas:Sprite;

	static public function start(config:GlueConfig)
	{
		var resolved = resolveConfig(config);

		Glue.stage = Lib.application.window.stage;
		Glue.width = Lib.application.window.width;
		Glue.height = Lib.application.window.height;
		
		Glue.mainScene = resolved.mainScene;
		Glue.isDebug = resolved.isDebug;
		Glue.showBounds = resolved.showBounds;
		customPreloader = resolved.preloader;
		
		canvas = new Sprite();
		Glue.stage.addChild(canvas);
		Glue.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		Glue.stage.addEventListener(Event.RESIZE, onStageResize);
		var appWindow = Lib.application.window;
		if (appWindow != null)
		{
			appWindow.onResize.add(onWindowResize);
		}

		refreshWindowSize();

		if (resolved.showStats)
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
				var loaderClass = customPreloader;
				if (loaderClass != null)
				{
					GSceneManager.showLoaderScene(loaderClass, onAssetsDownloaded);
				}
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

	static function onStageResize(_):Void
	{
		refreshWindowSize();
		if (GSceneManager.currentScene != null)
		{
			GSceneManager.currentScene.onResize();
		}

		if (GSceneManager.currentPopup != null)
		{
			GSceneManager.currentPopup.onResize();
		}
	}

	static function onWindowResize(width:Int, height:Int):Void
	{
		onStageResize(null);
	}

	static function refreshWindowSize():Void
	{
		Glue.width = Std.int(Glue.stage.stageWidth);
		Glue.height = Std.int(Glue.stage.stageHeight);
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

	static function resolveConfig(config:GlueConfig):ResolvedGlueConfig
	{
		return
		{
			mainScene: config.mainScene,
			preloader: config.preloader,
			isDebug: config.isDebug == true,
			showBounds: config.showBounds == true,
			showStats: config.showStats == true
		};
	}
}
