package glue.scene;

import glue.Glue;
import glue.GlueContext;
import glue.assets.Loader;

/**
 * Scene management system
 * Handles scene transitions, popups, and lifecycle
 * @author Jerson La Torre
 */

@:final class SceneManager
{
	static public var currentScene(default, null):Scene;
	static public var currentPopup(default, null):Popup;
	static var context:GlueContext;
		
	static public function init(glueContext:GlueContext)
	{
		context = glueContext;
		currentScene = null;
	}
	
	static public function gotoScene(sceneClass:Class<Scene>)
	{
		if (currentScene != null)
		{
			currentScene.destroy();
		}

		currentScene = cast Type.createInstance(sceneClass, [context]);
		Glue.stage.stageFocusRect = false;

		currentScene.preInit();
	}

	static public function showLoaderScene(loaderClass:Class<Popup>, callback:()->Void)
	{
		showPopup(loaderClass);
		Loader.startDownload(function()
		{
			removePopup();
			callback();
		});
	}

	static public function showPopup(popupClass:Class<Popup>)
	{
		if (currentPopup != null)
		{
			currentPopup.destroy();
		}
		
		currentPopup = cast Type.createInstance(popupClass, [context]);
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
