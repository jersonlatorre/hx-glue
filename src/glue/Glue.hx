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
	static public var stage:Stage;
	static public var mainScene:Dynamic;
	static public var customPreloader:Dynamic;
	static public var width:Int = 800;
	static public var height:Int = 600;
	static public var canvas:Sprite;
	static public var cacheCanvas:Sprite;
	static public var isDebug:Bool = false;
	
	static public function start(data:Dynamic)
	{
		Glue.stage = Lib.application.window.stage;
		Glue.width = Lib.application.window.width;
		Glue.height = Lib.application.window.height;
		
		Glue.mainScene = data.mainScene;
		Glue.isDebug = data.isDebug;
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

		if (data.assets == null)
		{
			GSceneManager.gotoScene(Glue.mainScene);
			return;
		}
		
		if (customPreloader != null)
		{
			GSceneManager.gotoScene(customPreloader);
		}
		else
		{
			GSceneManager.gotoScene(GPreloader);
		}
		
		if (data.assets != null)
		{
			for (i in 0...data.assets.length)
			{
				GLoader.load(data.assets[i]);
			}

			GLoader.startDownload(onAssetsDownloaded);
		}
	}

	static function onAssetsDownloaded() 
	{
		GSceneManager.gotoScene(Glue.mainScene);
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