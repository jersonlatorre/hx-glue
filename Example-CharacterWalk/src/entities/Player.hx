package entities;

import glue.utils.GTime;
import glue.input.GKey;
import glue.input.GInput;
import glue.Glue;
import glue.assets.GSound;
import glue.display.GSprite;
import glue.math.GVector2D;

/**
 * ...
 * @author Jerson La Torre
 */

class Player extends GSprite
{
	var _velocity:GVector2D = new GVector2D(0, 0);
	var _isJumping:Bool = false;

	var GRAVITY:GVector2D = new GVector2D(0, 2500);
	var JUMP_IMPULSE:GVector2D = new GVector2D(0, -900);
	var WALK_SPEED:GVector2D = new GVector2D(300, 0);
	var FLOOR_Y:Float = 460;

	override public function init()
	{
		addAnimation("idle", "player_idle", 30);
		addAnimation("walk", "player_walk", 30);
		addAnimation("jump", "player_jump", 30);
		play("idle");

		setAnchor(0.5, 1);
		setPosition(Glue.width / 2, FLOOR_Y);

		GInput.bindKeys("jump", [GKey.UP, GKey.W]);
		GInput.bindKeys("right", [GKey.RIGHT, GKey.D]);
		GInput.bindKeys("left", [GKey.LEFT, GKey.A]);
	}
	
	override public function update()
	{
		/**
		 *  Walk
		 */

		if (GInput.isKeyPressed("right"))
		{
			_velocity.x = WALK_SPEED.x;
			setScaleX(1);
		}

		if (GInput.isKeyPressed("left"))
		{
			_velocity.x = -WALK_SPEED.x;
			setScaleX(-1);
		}
		
		if (!GInput.isKeyPressed("right") && !GInput.isKeyPressed("left"))
		{
			// _velocity.x = 0;
			_velocity.x *= 0.90;
			
			if (Math.abs(_velocity.x) < 10) _velocity.x = 0;

			if (position.x <= width / 2 || position.x >= Glue.width - width / 2)
			{
				_velocity.x = 0;
			}
		}


		/**
		 *  Jump
		 */

		if (GInput.isKeyPressed("jump") && !_isJumping)
		{
			GSound.play("jump");
			_isJumping = true;
			_velocity.y = JUMP_IMPULSE.y;
		}

		/**
		 *  Physics
		 */

		_velocity += GRAVITY * GTime.deltaTime;
		position += _velocity * GTime.deltaTime;


		/**
		 *  Ground detection
		 */

		if (position.y > FLOOR_Y)
		{
			position.y = FLOOR_Y;
			_isJumping = false;
		}
		

		/**
		 *  Bound limits
		 */
		 
		if (position.x >= Glue.width - width / 2) position.x = Glue.width - width / 2;
		if (position.x <= width / 2) position.x = width / 2;

		/**
		 *  Select the correct animation
		 */
		 
		if (_isJumping)
		{
			play("jump");
		}
		else
		{
			if (_velocity.x != 0)
			{
				play("walk");
			}
			else
			{
				play("idle");
			}
		}
	}
}