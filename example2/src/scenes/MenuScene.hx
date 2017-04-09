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
	// var _playButton:GButton;
	// var _background:GImage;

	override public function preload()
	{
		// load({ type:"image", src:"img/button_play.png", id:"button" });
	}

	override public function init()
	{
		// var button = new GImage("button").addTo(this);
		GSceneManager.gotoScene(GameScene);
		// _background = new GImage("background_game")
		// .addTo(this);

		// _playButton = new GButton("button_play")
		// .addTo(this).onClick(function() { GSceneManager.gotoScene(GameScene); })
		// .setPosition(Glue.width / 2, Glue.height / 2)
		// .setAnchor(0.5, 0.5);
		
		// fadeIn();
	}
	
	override public function update()
	{
	}
}