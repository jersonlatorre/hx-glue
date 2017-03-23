package com.plug.ui;

import com.glue.display.GSprite;
import com.glue.display.GImage;
import com.glue.Glue;
import com.glue.ui.GScene;
import com.plug.entities.Player;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class SceneGame extends GScene
{
	var _background:GImage;
	var _floor:GImage;
	var _player:GSprite;
	
	public function new()
	{
		super();
		
		_background = new GImage("background_game")
			.addTo(this);

		_floor = new GImage("floor")
			.setPosition(0, Glue.height - 250)
			.addTo(this);

		// _player = new Player();
		// addEntity(_player);

		_player = new GSprite()
			.addAnimation("player_idle", 60)
			.play()
			.setPosition(100, 100)
			.addTo(this);

		// camera.follow(_player)
		// 	.setBottomLimit(GEngine.height)
		// 	.setLeftLimit(0)
		// 	.setRightLimit(GEngine.width);
	}
	
	override public function update():Void
	{
		super.update();
	}
}