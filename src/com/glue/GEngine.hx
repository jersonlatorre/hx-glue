package com.glue;
import com.glue.data.GImageManager;
import com.glue.data.GLoaderManager;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GSceneManager;
import com.glue.utils.GStats;
import com.glue.utils.GTime;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.text.TextFieldAutoSize;
import com.glue.ui.GPreloader;

/**
 * ...
 * @author Uno
 */

@final class GEngine
{
	static public var stage:Stage;
	static public var mainScreen:Dynamic;
	static public var isDebug:Bool = false;
	static public var isEmbedded:Bool = false;
	static public var showFPS:Bool;
	static public var assetsInfo:Array<Dynamic>;
	static public var customPreloader:Dynamic;
	
	static public var width:Int;
	static public var height:Int;
	
	static public var canvas:Sprite;
	
	static var _stats:GStats;
	static var _statsCanvas:Sprite;

	static public function start(data:Dynamic)
	{
		GEngine.stage = data.stage;
		GEngine.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		
		GEngine.width = data.width;
		GEngine.height = data.height;
		
		canvas = new Sprite();
		GEngine.stage.addChild(canvas);
		
		_statsCanvas = new Sprite();
		GEngine.stage.addChild(_statsCanvas);
		
		GMouse.init();
		GKeyboard.init();
		GTime.init();
		GSceneManager.init();
		
		if (showFPS)
		{
			// FPS counter
			
			_stats = new GStats();
			_stats.background = true;
			_stats.backgroundColor = 0xFFFFFF;
			_statsCanvas.addChild(_stats);
		}
		
		loadAssets();
		
		if (!isEmbedded)
		{
			if (customPreloader != null)
			{
				GSceneManager.gotoScreen(customPreloader);
			}
			else
			{
				GSceneManager.gotoScreen(GPreloader);
			}
		}
	}
	
	static function loadAssets(callback:Dynamic = null):Void
	{
		var i:Int;
		trace(GEngine.assetsInfo);
		
		for (i in 0...GEngine.assetsInfo.length)
		{
			var file:Dynamic = GEngine.assetsInfo[i];
			
			switch(file.type)
			{
				case "image":
				{
					GLoaderManager.addImage(file.url, file.id);
				}
				
				case "sprite":
				{
					GLoaderManager.addImage(file.url + ".png", file.id);
					GLoaderManager.addData(file.url + ".json", file.id);
				}
				
				case "data":
				{
					GLoaderManager.addData(file.url, file.id);
				}
				
				case "bitmapfont":
				{
					GLoaderManager.addImage(file.url + ".png", file.id);
					GLoaderManager.addData(file.url + ".fnt", file.id);
				}
				
				case "sound":
				{
					GLoaderManager.addSound(file.url, file.id, file.group != null ? file.group : "default");
				}
			}
		}
		
		GLoaderManager.startDownload(onAssetsDownloaded);
	}
	
	static function onAssetsDownloaded() 
	{
		GSceneManager.gotoScreen(GEngine.mainScreen);
	}
	
	static public function onUpdate(e:Event):Void
	{
		stage.focus = canvas;
		
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