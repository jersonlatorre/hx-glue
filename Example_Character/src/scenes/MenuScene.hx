package scenes;

import glue.Glue;
import glue.scene.GScene;
import glue.display.GImage;
import glue.display.GButton;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class MenuScene extends GScene
{
	override public function preload()
	{
		loadImage("menu_background", "img/menu_background.png");
		loadButton("button_play", "img/button_play.png");
	}

	override public function init()
	{
		new GImage("menu_background").addTo(this);

		new GButton("button_play")
		.addTo(this)
		.setAnchor(0.5, 0.5)
		.setPosition(Glue.width / 2, Glue.height / 2)
		.onClick(function()
		{
			gotoScene(GameScene);
		});

		fadeIn();
	}
}