package example1;

import glue.data.GLoader;
import glue.utils.GVector2D;
import glue.utils.GTime;
import glue.Glue;
import glue.display.GSprite;
import glue.display.GImage;
import glue.ui.GScene;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class Example1 extends GScene
{
	var _background:GImage;
	var _floor:GImage;
	var _player:GSprite;

	var _velocity:GVector2D = GVector2D.create(0, 0);
	var _gravity:GVector2D = GVector2D.create(0, 800);
	var _jumpImpulse:GVector2D = GVector2D.create(0, -1000);

	override public function load():Void
	{
		/**
		 *  Load scene assets.
		 */
		// GLoader.load({ type:"image", src:"img/background_game.png", id:"background_game" });
		GLoader.load({ type:"image", src:"img/floor.png", id:"floor" });
		GLoader.load({ type:"spritesheet", src:"img/player_idle.png", id:"player_idle" });
	}

	override public function init():Void
	{
			addLayer("world");
			addLayer("ui");

		_background = new GImage("background_game")
			.setAnchor(0, 0).addTo(this, "world");

		_floor = new GImage("floor")
			.setPosition(0, Glue.height - 250)
			.addTo(this, "world");

		_player = new GSprite()
			.addAnimation("player_idle")
			.setAnchor(0.5, 1)
			.play()
			.setPosition(200, 200)
			.addTo(this, "world");

		fadeIn();
	}
	
	override public function update():Void
	{
		_velocity += _gravity * GTime.deltaTime;
		_player.position += _velocity * GTime.deltaTime;
		
		if (_player.position.y >= 1500)
		{
			_velocity = _jumpImpulse;
		}
		
		super.update();
	}
}