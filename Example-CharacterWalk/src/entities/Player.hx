package entities;

import glue.input.GKeyboard;
import glue.Glue;
import glue.display.GSprite;
import glue.input.GMouse;
import glue.utils.GTime;
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
	}
	
	override public function update()
	{
		/**
		 *  Walk
		 */

		if (GKeyboard.isLeft)
		{
			_velocity.x = -WALK_SPEED.x;
			setScaleX(-1);
		}
		
		if (GKeyboard.isRight)
		{
			_velocity.x = WALK_SPEED.x;
			setScaleX(1);
		}
		
		if (!GKeyboard.isRight && !GKeyboard.isLeft)
		{
			_velocity.x = 0;
		}


		/**
		 *  Jump
		 */

		if (GKeyboard.isUp && !_isJumping)
		{
			_isJumping = true;
			_velocity.y = JUMP_IMPULSE.y;
		}

		if (_isJumping)
		{
			if (position.y >= FLOOR_Y)
			{
				position.y = FLOOR_Y;
				_isJumping = false;
			}
		}


		/**
		 *  velocity += acceleration
		 *  position += velocity
		 */

		_velocity += GRAVITY * GTime.deltaTime;
		position += _velocity * GTime.deltaTime;
		

		/**
		 *  Limit bounds
		 */
		 
		if (position.x >= 800 - 30) position.x = 800 - 30;
		if (position.x <= 30) position.x = 30;
		if (position.y >= FLOOR_Y) position.y = FLOOR_Y;


		/**
		 *  Play the correct animation
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