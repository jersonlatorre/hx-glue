package com.glue;
import com.glue.data.GLoader;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GSceneManager;
import com.glue.utils.GTime;
// import nape.phys.Body;
// import nape.phys.BodyType;
// import nape.shape.Polygon;
// import nape.space.Space;
// import nape.util.BitmapDebug;
// import nape.util.Debug;
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
	
	// static public var space:Space;
	// static public var debug:Debug;
	// static public var box:Body;

	static public function start(data:Dynamic)
	{
		GEngine.stage = data.stage;
		GEngine.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		GEngine.width = data.width;
		GEngine.height = data.height;
		GEngine.mainScene = data.mainScene;
		
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
		
		initializePhysics();
		
		GLoader.load(onAssetsDownloaded);
	}
	
	static private function initializePhysics():Void
	{
		// space = new Space(Vec2.weak(0, 600));
	}
	
	static function onAssetsDownloaded() 
	{
		GSceneManager.gotoScene(GEngine.mainScene);
	}
	
	static public function onUpdate(e:Event):Void
	{
		// stage.focus = canvas;
		// space.step(1 / 60);
		
		//trace(box.position);
		
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