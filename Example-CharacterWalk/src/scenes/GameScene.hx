package scenes;

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
	}

	override public function init()
	{
		new GImage("game_background").addTo(this);
		
		_player = new Player().addTo(this);
		fadeIn();
	}
	
	override public function update()
	{
		
	}
}