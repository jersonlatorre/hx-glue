package glue.ui;

import glue.Glue;
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
	static public var currentPopup:GScene;
	
	static public function init():Void
	{
		GSceneManager.canvas = Glue.canvas;
		currentScene = null;
	}
	
	static public function gotoScene(screenClass:Dynamic):Void
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

		preInitScene();
	}
	
	static function preInitScene()
	{
		currentScene.preInit();
	}

	static public function showPopup(popupClass:Dynamic):Void
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
		currentPopup.preUpdate();
	}
	
	static public function removePopup():Void
	{
		if (currentPopup != null)
		{
			currentPopup.destroy();
			currentPopup = null;
		}
	}
	
	static public function update():Void
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