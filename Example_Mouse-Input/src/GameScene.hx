package;

import glue.input.GMouse;
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

class GameScene extends GScene
{
	var _velocity:GVector2D = GVector2D.create(0, 0);
	var _gravity:GVector2D = GVector2D.create(0, 800);
	var _jumpImpulse:GVector2D = GVector2D.create(0, -800);

	var _background:GImage;
	var _floor:GImage;
	var _player:GSprite;

	static inline var FOLLOW_DRAG:Float = 2;

	override public function preload():Void
	{
		/**
		 *  Load scene assets here.
		 *  Is it not necessary to load assets in this case because
		 *  all the assets where loaded in the Main class.
		 */
	}

	override public function init():Void
	{
		/**
		 *  Create an image and add it to the world.
		 */
		_background = new GImage("background_game");
		_background.addTo(this);


		/**
		 *  Create an image and change it's position.
		 */
		_floor = new GImage("floor");
		_floor.setPosition(0, Glue.height - _floor.height);
		addEntity(_floor); // Another way to add an entity to the world.


		/**
		 *  You can chain all the GSprite methods in one line, like this:
		 */
		_player = new GSprite("player_idle")
		.play().setScale(0.85, 0.85)
		.setAnchor(0.5, 1)
		.setPosition(200, 200)
		.addTo(this);


		/**
		 *  Shows a little fadeIn when the scene starts.
		 */
		fadeIn();
	}
	
	override public function update():Void
	{
		/**
		 *  Doing the physics:
		 *  
		 *  velocity += acceleration
		 *  position += velocity
		 *  
		 *  GTime provides the deltaTime property.
		 */
		_velocity += _gravity * GTime.deltaTime;
		_player.position += _velocity * GTime.deltaTime;

		/**
		 *  Move the player following the mouse.
		 */
		 _player.position.x = _player.position.x + FOLLOW_DRAG * GTime.deltaTime * (GMouse.position - _player.position).x;
		
		/**
		 *  Jump!
		 */
		if (_player.position.y >= Glue.height - _floor.height)
		{
			_player.position.y = Glue.height - _floor.height;
			_velocity = _jumpImpulse;
		}
	}
}