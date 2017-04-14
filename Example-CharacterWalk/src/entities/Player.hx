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
	var SPEED_X:Float = 300;
	var GRAVITY:GVector2D = new GVector2D(0, 2000);
	var JUMP_IMPULSE:GVector2D = new GVector2D(0, -800);
	var _velocity:GVector2D = new GVector2D(0, 0);
	var _speedX:Float = 0;
	var _isJumping:Bool = false;
	

	override public function init()
	{
		addAnimation("idle", "player_idle", 30);
		addAnimation("walk", "player_walk", 30);
		addAnimation("jump", "player_jump", 30);
		play("idle");

		setAnchor(0.5, 1);
		setPosition(Glue.width / 2, Glue.height - 60);
	}
	
	override public function update()
	{
		/**
		 *  Walk
		 */

		if (GKeyboard.isLeft || (GMouse.isPressed && GMouse.position.x < 400))
		{
			_speedX = -SPEED_X;
			setScaleX(-1);
		}
		
		if (GKeyboard.isRight || (GMouse.isPressed && GMouse.position.x >= 400))
		{
			_speedX = SPEED_X;
			setScaleX(1);
		}
		
		if (!GKeyboard.isRight && !GKeyboard.isLeft && !GMouse.isPressed)
		{
			_speedX = 0;
		}

		position.x += _speedX * GTime.deltaTime;


		/**
		 *  Jump
		 */

		if (GKeyboard.isUp && !_isJumping)
		{
			_isJumping = true;
			_velocity = JUMP_IMPULSE;
		}

		if (_isJumping)
		{
			if (position.y >= Glue.height - 60)
			{
				position.y = Glue.height - 60;
				_isJumping = false;
			}
		}

		_velocity += GRAVITY * GTime.deltaTime;
		position += _velocity * GTime.deltaTime;
		

		/**
		 *  Limit bounds
		 */
		 
		if (position.x >= 800 - 35)
		{
			position.x = 800 - 35;
		}
		
		if (position.x <= 35)
		{
			position.x = 35;
		}

		if (position.y >= Glue.height - 60)
		{
			position.y = Glue.height - 60;
		}


		/**
		 *  Play the correct animation
		 */
		 
		if (_isJumping)
		{
			play("jump");
		}
		else
		{
			if (_speedX != 0)
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