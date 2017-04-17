package glue;

import openfl.Lib;
import glue.assets.GLoader;
import glue.scene.GPreloader;
import glue.input.GKeyboard;
import glue.input.GMouse;
import glue.scene.GSceneManager;
import glue.utils.GTime;
import glue.utils.GStats;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

@:final class Glue
{
	static var mainScene:Dynamic;
	static var customPreloader:Dynamic;
	static var isPreloading:Bool;

	static public var stage:Stage;
	static public var width:Int = 800;
	static public var height:Int = 600;
	static public var canvas:Sprite;
	static public var isDebug:Bool = false;

	@:allow(glue.assets.GLoader)
	static var cacheCanvas:Sprite;

	static public function start(data:Dynamic)
	{
		Glue.stage = Lib.application.window.stage;
		Glue.width = Lib.application.window.width;
		Glue.height = Lib.application.window.height;
		
		Glue.mainScene = data.mainScene;
		Glue.isDebug = data.isDebug;
		customPreloader = data.preloader;
		
		Glue.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
			
		cacheCanvas = new Sprite();
		cacheCanvas.x = Math.NEGATIVE_INFINITY;
		cacheCanvas.alpha = 0.0001;
		Glue.stage.addChild(cacheCanvas);

		canvas = new Sprite();
		Glue.stage.addChild(canvas);

		if (data.showStats)
		{
			var stats = new GStats();
			Glue.stage.addChild(stats);
		}
		
		GTime.init();
		GMouse.init();
		GKeyboard.init();
		GSceneManager.init();

		if (isPreloading)
		{
			if (customPreloader == null)
			{
				GSceneManager.showLoaderScene(GPreloader, onAssetsDownloaded);
			}
			else
			{
				GSceneManager.showLoaderScene(customPreloader, onAssetsDownloaded);
			}
		}
		else
		{
			GSceneManager.gotoScene(Glue.mainScene);
		}
	}

	static public function loadImage(id:String, url:String)
	{
		GLoader.load({ type:'image', url: url, id: id });
	}

	static public function loadSpritesheet(id:String, url:String)
	{
		GLoader.load({ type:'spritesheet', url: url, id: id });
	}

	static public function loadButton(id:String, url:String)
	{
		GLoader.load({ type:'button', url: url, id: id });
	}

	static public function loadJson(id:String, url:String)
	{
		GLoader.load({ type:'data', url: url, id: id });
	}

	public function loadSound(id:String, url:String, group:String)
	{
		GLoader.load({ type:'sound', url: url, id: id, group:group });
	}

	static function onAssetsDownloaded() 
	{
		GSceneManager.gotoScene(Glue.mainScene);
	}
	
	static function onUpdate(e:Event)
	{
		GTime.update();	
		GMouse.update();
		GSceneManager.update();
		GMouse.clear();
		GKeyboard.update();
	}
	
	static public function setScale(x:Float, y:Float)
	{
		canvas.scaleX = x;
		canvas.scaleY = y;
	}
}