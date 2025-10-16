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
	
	static public function gotoScene(sceneClass:Class<GScene>)
	{
		if (currentScene != null)
		{
			currentScene.destroy();
		}

		currentScene = cast Type.createInstance(sceneClass, []);
		Glue.stage.stageFocusRect = false;

		currentScene.preInit();
	}

	static public function showLoaderScene(loaderClass:Class<GPopup>, callback:Void->Void)
	{
		showPopup(loaderClass);
		GLoader.startDownload(function()
		{
			removePopup();
			callback();
		});
	}

	static public function showPopup(popupClass:Class<GPopup>)
	{
		if (currentPopup != null)
		{
			currentPopup.destroy();
		}
		
		currentPopup = cast Type.createInstance(popupClass, []);
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
