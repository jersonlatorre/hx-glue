package scenes;

import glue.ui.GScene;
import glue.display.GImage;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class MenuScene extends GScene
{
	var _background:GImage;
	
	override public function preload()
	{
		load({ type:"image", src:"img/game_background.png", id:"game_background" });
		load({ type:"button", src:"img/button_play.png", id:"button_play" });
	}

	override public function init()
	{
		gotoScene(GameScene);
	}
	
	override public function update()
	{
	}
}