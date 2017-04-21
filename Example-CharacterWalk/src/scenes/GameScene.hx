package scenes;

import glue.assets.GSound;
import glue.input.GInput;
import glue.display.GImage;
import entities.Player;
import glue.scene.GScene;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class GameScene extends GScene
{
	var _player:Player;

	override public function preload()
	{
		loadImage("game_background", "images/game_background.png");
		loadSpritesheet("player_idle", "images/player_idle.png");
		loadSpritesheet("player_walk", "images/player_walk.png");
		loadSpritesheet("player_jump", "images/player_jump.png");
		
		// #if (cpp)
		loadSound("bgm_game", "sounds/bgm_game.ogg");
		loadSound("jump", "sounds/jump.ogg");
		// #else
		// loadSound("bgm_game", "sounds/bgm_game.mp3");
		// loadSound("jump", "sounds/jump.mp3");
		// #end
	}

	override public function init()
	{
		GSound.loop("bgm_game");
		
		var background = new GImage();
		background.createFromAsset("game_background");
		add(background);

		_player = new Player();
		add(_player);

		fadeIn();
	}
	
	override public function update()
	{
		if (GInput.isMouseDown)
		{
			gotoScene(MenuScene);
			GSound.stopAll();
		}
	}
}