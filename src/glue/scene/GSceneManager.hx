package glue.scene;

import glue.Glue;
import glue.assets.GLoader;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

@:final class GSceneManager 
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
		var sceneClass:Class<Dynamic> = cast screenClass;
		if (!inheritsFrom(sceneClass, GScene))
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
		var popupClassRef:Class<Dynamic> = cast popupClass;
		if (!inheritsFrom(popupClassRef, GPopup))
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

	static function inheritsFrom(clazz:Class<Dynamic>, parent:Class<Dynamic>):Bool
	{
		var current:Class<Dynamic> = clazz;
		while (current != null)
		{
			if (current == parent)
			{
				return true;
			}
			current = Type.getSuperClass(current);
		}
		return false;
	}
}
