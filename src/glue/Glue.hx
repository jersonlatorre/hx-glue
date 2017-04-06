package glue;

import haxe.Timer;
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
	static public var stage:Stage;
	static public var mainScene:Dynamic;
	static public var customPreloader:Dynamic;
	static public var width:Int;
	static public var height:Int;
	static public var canvas:Sprite;
	static public var cacheCanvas:Sprite;
	
	static public function start(data:Dynamic)
	{
		Glue.stage = data.stage;
		Glue.width = data.width;
		Glue.height = data.height;
		Glue.mainScene = data.mainScene;
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
		#if html5
		// prudential time to preload all files for html5
		var timer = new Timer(2500);
		timer.run = function()
		{
			GSceneManager.gotoScene(Glue.mainScene);
			timer.stop();
		};
		#else
		GSceneManager.gotoScene(Glue.mainScene);
		#end
	}
	
	static public function onUpdate(e:Event):Void
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