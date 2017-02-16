package com.glue.ui;

import com.glue.GEngine;
import flash.display.Sprite;

/**
 * ...
 * @author guarajeno
 */

class GSceneManager 
{
	static public var canvas:Sprite;
	static public var popupCanvas:Sprite;
	static public var sceneCanvas:Sprite;
	
	static public var currentScene:GScene;
	static public var currentPopup:GScene;
	
	static public function init():Void
	{
		GSceneManager.canvas = GEngine.canvas;
		
		popupCanvas = new Sprite();
		sceneCanvas = new Sprite();
		
		canvas.addChild(sceneCanvas);
		canvas.addChild(popupCanvas);
		
		currentScene = null;
	}
	
	static public function gotoScene(screenClass:Dynamic):Void
	{
		if (Type.getSuperClass(screenClass) != GScene)
		{
			trace("GScreenManager::gotoScreen -> screenClass need to be a GScreen");
			return;
		}
		
		if (currentScene != null)
		{
			currentScene.destroy();
		}
		
		currentScene = Type.createInstance(screenClass, []);
		currentScene.update();
		
		GEngine.stage.stageFocusRect = false;
		GEngine.stage.focus = sceneCanvas;
	}
	
	static public function showPopup(popupClass:Dynamic):Void
	{
		if (Type.getSuperClass(popupClass) != GPopup)
		{
			trace("GScreenManager::showPopup -> popupClass need to be a GPopup");
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