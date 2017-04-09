package scenes;

import glue.Glue;
import glue.ui.GScene;
import glue.ui.GSceneManager;
import glue.display.GButton;
import glue.display.GImage;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class MenuScene extends GScene
{
	override public function preload()
	{
	}

	override public function init()
	{
		GSceneManager.gotoScene(GameScene);
	}
	
	override public function update()
	{
	}
}