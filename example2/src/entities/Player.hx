package entities;

import glue.input.GKeyboard;
import glue.Glue;
import glue.display.GSprite;
import glue.input.GMouse;
import glue.utils.GTime;
import glue.utils.GVector2D;

/**
 * ...
 * @author Jerson La Torre
 */

class Player extends GSprite
{
	static inline private var SPEED_X:Float = 90;
	private var _speedX:Float;
	public var isPaused:Bool = false;

	override public function init()
	{
		addAnimation("idle", "player_idle", 30);
		addAnimation("walk", "player_walk", 30);
		addAnimation("die", "player_die", 30);
		play("idle");

		setAnchor(0.5, 1);
		setPosition(Glue.width / 2, Glue.height - 250);
	}
	
	override public function update()
	{
		if (isPaused) return;
		
		if (GKeyboard.isLeft || (GMouse.isDown && GMouse.position.x < 400))
		{
			_speedX = -SPEED_X;
			setScaleX(-1);
			play("walk");
		}
		
		if (GKeyboard.isRight || (GMouse.isDown && GMouse.position.x >= 400))
		{
			_speedX = SPEED_X;
			setScaleX(1);
			play("walk");
		}
		
		if (!GKeyboard.isRight && !GKeyboard.isLeft && !GMouse.isDown)
		{
			_speedX = 0;
			play("idle");
		}
		
		position.x += _speedX * GTime.deltaTime;
		
		if (position.x >= 800 - 30)
		{
			position.x = 800 - 30;
		}
		
		if (position.x <= 30)
		{
			position.x = 30;
		}
	}
	
	public function die() 
	{
		// isDead = true;
		// setAnimation("die");
	}
}