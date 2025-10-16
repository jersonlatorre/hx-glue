package glue;

import glue.assets.Loader;
import glue.scene.Preloader;
import glue.scene.Scene;
import glue.scene.Popup;
import glue.scene.SceneManager;
import glue.utils.Time;
import glue.utils.Stats;
import glue.input.Input;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

typedef GlueOptions =
{
	@:optional var preloader:Null<Class<Popup>>;
	@:optional var showStats:Bool;
}

@:final class Glue
{
	static var mainScene:Class<Scene>;
	static var customPreloader:Null<Class<Popup>>;
	static var context:GlueContext;

	static public var stage:Stage;
	static public var width:Int;
	static public var height:Int;
	static public var canvas:Sprite;
	static public var isDebug:Bool = false;
	static public var showBounds:Bool = false;

	@:allow(glue.assets.Loader)
	static var cacheCanvas:Sprite;

	static public function run<TScene:Scene>(sceneClass:Class<TScene>, ?options:GlueOptions)
	{
		var resolved = resolveOptions(options);

		Glue.stage = Lib.application.window.stage;
		Glue.width = Lib.application.window.width;
		Glue.height = Lib.application.window.height;

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

		context = new GlueContext(Glue.stage, canvas, Glue.width, Glue.height);

		mainScene = cast sceneClass;
		customPreloader = resolved.preloader;

		if (resolved.showStats == true)
		{
			var stats = new Stats();
			Glue.stage.addChild(stats);
		}

		Time.init();
		Input.init();
		SceneManager.init(context);

		if (customPreloader == null)
		{
			SceneManager.showLoaderScene(Preloader, onAssetsDownloaded);
		}
		else
		{
			var loaderClass = customPreloader;
			if (loaderClass != null)
			{
				SceneManager.showLoaderScene(loaderClass, onAssetsDownloaded);
			}
		}
	}

	static function onAssetsDownloaded()
	{
		SceneManager.gotoScene(mainScene);
	}

	static function onUpdate(_)
	{
		Time.update();
		Input.update();
		SceneManager.update();
		Input.clear();
	}

	static function onStageResize(_):Void
	{
		refreshWindowSize();
		context.updateSize(Glue.width, Glue.height);

		if (SceneManager.currentScene != null)
		{
			SceneManager.currentScene.onResize();
		}

		if (SceneManager.currentPopup != null)
		{
			SceneManager.currentPopup.onResize();
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
				Loader.load({ type:"adobe_animate_spritesheet", id: assetId, url: url, fps: fps });
			}
		},

		image: function(assetId:String, url:String)
		{
			Loader.load({ type: "image", id: assetId, url: url });
		},

		json: function(assetId:String, url:String)
		{
			Loader.load({ type: "json", id: assetId, url: url });
		},

		sound: function(assetId:String, url:String, group:String = null)
		{
			Loader.load({ type: "sound", id: assetId, url: url, group: group});
		}
	}

	static function resolveOptions(options:GlueOptions):GlueOptions
	{
		return
		{
			preloader: options != null ? options.preloader : null,
			showStats: options != null && options.showStats == true
		};
	}
}
