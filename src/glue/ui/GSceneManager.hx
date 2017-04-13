package glue.ui;

import glue.Glue;
import glue.data.GLoader;
import openfl.display.Sprite;
import glue.utils.GTools;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GSceneManager 
{
	static public var canvas:Sprite;
	static public var currentScene:GScene;
	static public var currentPopup:GPopup;
	
	static public function init()
	{
		GSceneManager.canvas = Glue.canvas;
		currentScene = null;
	}
	
	static public function gotoScene(screenClass:Dynamic)
	{
		if (Type.getSuperClass(screenClass) != GScene)
		{
			throw "Screen class needs to be GScreen";
		}
		
		if (currentScene != null)
		{
			currentScene.destroy();
		}

		currentScene = Type.createInstance(screenClass, []);
		Glue.stage.stageFocusRect = false;

		currentScene.preInit();
	}

	static public function showLoaderScene(loaderClass:Dynamic, callback:Dynamic)
	{
		showPopup(loaderClass);
		GLoader.startDownload(function()
		{
			removePopup();
			callback();
		});
	}

	static public function showPopup(popupClass:Dynamic)
	{
		if (Type.getSuperClass(popupClass) != GPopup)
		{
			throw "Popup Class needs to be GPopup";
		}
		
		if (currentPopup != null)
		{
			currentPopup.destroy();
		}
		
		currentPopup = Type.createInstance(popupClass, []);
		currentPopup.preInit();
	}
	
	static public function removePopup()
	{
		if (currentPopup != null)
		{
			currentPopup.destroy();
			currentPopup = null;
		}
	}
	
	static public function update()
	{
		if (currentScene != null)
		{
			currentScene.preUpdate();
		}
		
		if (currentPopup != null)
		{
			currentPopup.preUpdate();
		}
	}
}