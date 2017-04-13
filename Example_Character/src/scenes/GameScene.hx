package scenes;

import entities.Player;
import glue.ui.GScene;

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
		load({ type:"spritesheet", src:"img/player_idle.png", id:"player_idle" });
		load({ type:"spritesheet", src:"img/player_walk.png", id:"player_walk" });
		load({ type:"image", src:"img/game_background.png", id:"game_background" });
	}

	override public function init()
	{
		_player = new Player().addTo(this);
		fadeIn();
	}
	
	override public function update()
	{
		
	}
}