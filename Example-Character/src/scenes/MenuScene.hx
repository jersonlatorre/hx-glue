package scenes;

import glue.Glue;
import glue.ui.GScene;
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
		load({ type:"image", src:"img/menu_background.png", id:"menu_background" });
		load({ type:"button", src:"img/button_play.png", id:"button_play" });
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