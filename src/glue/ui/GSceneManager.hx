package glue.ui;

import glue.Glue;
import openfl.display.Sprite;

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
			throw "GScreenManager::gotoScreen -> screenClass needs to be GScreen";
			return;
		}
		
		if (currentScene != null)
		{
			currentScene.destroy();
		}
		
		currentScene = Type.createInstance(screenClass, []);
		currentScene.update();
		
		Glue.stage.stageFocusRect = false;
	}
	
	static public function showPopup(popupClass:Dynamic):Void
	{
		if (Type.getSuperClass(popupClass) != GPopup)
		{
			trace("GScreenManager::showPopup -> popupClass needs to be GPopup");
			return;
		}
		
		if (currentPopup != null)
		{
			currentPopup.destroy();
		}
		
		currentPopup = Type.createInstance(popupClass, []);
		currentPopup.update();
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
			currentScene.update();
		}
		
		if (currentPopup != null)
		{
			currentPopup.update();
		}
	}
}