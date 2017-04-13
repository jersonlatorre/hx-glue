package glue;

import openfl.Lib;
import glue.data.GLoader;
import glue.input.GKeyboard;
import glue.input.GMouse;
import glue.ui.GSceneManager;
import glue.utils.GTime;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import glue.ui.GPreloader;

@final class Glue
{
	static var mainScene:Dynamic;
	static var customPreloader:Dynamic;
	static var isPreloading:Bool;

	static public var stage:Stage;
	static public var width:Int = 800;
	static public var height:Int = 600;
	static public var canvas:Sprite;
	static public var isDebug:Bool = false;

	@:allow(glue.data.GLoader)
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

	static public function load(data:Dynamic)
	{
		GLoader.load(data);
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
	}
	
	static public function setScale(x:Float, y:Float)
	{
		canvas.scaleX = x;
		canvas.scaleY = y;
	}
}