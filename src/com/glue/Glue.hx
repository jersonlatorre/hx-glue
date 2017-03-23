package com.glue;

import com.glue.data.GLoader;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GSceneManager;
import com.glue.utils.GTime;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import com.glue.ui.GPreloader;

@final class Glue
{
	static public var stage:Stage;
	static public var mainScene:Dynamic;
	static public var customPreloader:Dynamic;
	static public var width:Int;
	static public var height:Int;
	static public var canvas:Sprite;
	
	static public function start(data:Dynamic)
	{
		Glue.stage = data.stage;
		Glue.width = data.width;
		Glue.height = data.height;
		Glue.mainScene = data.mainScene;
		Glue.stage.addEventListener(Event.ENTER_FRAME, onUpdate);

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
		GSceneManager.gotoScene(Glue.mainScene);
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