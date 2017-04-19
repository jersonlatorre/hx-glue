package scenes;

import glue.assets.GSound;
import glue.Glue;
import glue.scene.GScene;
import glue.display.GImage;
import glue.display.GButton;
import openfl.media.Sound;
import openfl.media.SoundChannel;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class MenuScene extends GScene
{
	var sound:Sound;
	var channel:SoundChannel;
	
	override public function preload()
	{
		loadImage("menu_background", "images/menu_background.png");
		loadButton("button_play", "images/button_play.png");

		#if (html5 || cpp)
		loadSound("button_over", "sounds/button_over.ogg", "fx");
		loadSound("button_down", "sounds/button_down.ogg", "fx");
		loadSound("bgm_menu", "sounds/bgm_menu.ogg", "music");
		#else
		loadSound("button_over", "sounds/button_over.mp3", "fx");
		loadSound("button_down", "sounds/button_down.mp3", "fx");
		loadSound("bgm_menu", "sounds/bgm_menu.mp3", "music");
		#end
	}

	override public function init()
	{
		GSound.loop("bgm_menu");

		new GImage("menu_background").addTo(this);

		new GButton("button_play")
			.addTo(this)
			.setAnchor(0.5, 0.5)
			.setPosition(Glue.width / 2, Glue.height / 2)
			.onMouseEnter(function()
			{
				GSound.play("button_over");
			})
			.onMouseDown(function()
			{
				GSound.play("button_down");
			})
			.onClick(function()
			{
				GSound.stop("bgm_menu");
				gotoScene(GameScene);
			});

		fadeIn();
	}
}