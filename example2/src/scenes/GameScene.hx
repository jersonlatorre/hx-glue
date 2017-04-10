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
		load({ type:"spritesheet", src:"img/player_die.png", id:"player_die" });
		load({ type:"spritesheet", src:"img/item_good_stand.png", id:"item_good_stand" });
		load({ type:"spritesheet", src:"img/item_good_die.png", id:"item_good_die" });
		load({ type:"spritesheet", src:"img/item_bad_stand.png", id:"item_bad_stand" });
		load({ type:"spritesheet", src:"img/item_bad_die.png", id:"item_bad_die" });
		load({ type:"image", src:"img/game_background.png", id:"game_background" });
	}

	override public function init()
	{
		_player = new Player().addTo(this);
	}
	
	override public function update()
	{
	}
}