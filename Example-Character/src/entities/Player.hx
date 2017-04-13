package entities;

import glue.input.GKeyboard;
import glue.Glue;
import glue.display.GSprite;
import glue.input.GMouse;
import glue.utils.GTime;

/**
 * ...
 * @author Jerson La Torre
 */

class Player extends GSprite
{
	static inline private var SPEED_X:Float = 250;
	private var _speedX:Float;

	override public function init()
	{
		addAnimation("idle", "player_idle", 45);
		addAnimation("walk", "player_walk", 45);
		play("idle");

		setAnchor(0.5, 1);
		setPosition(Glue.width / 2, Glue.height - 150);
	}
	
	override public function update()
	{
		if (GKeyboard.isLeft || (GMouse.isPressed && GMouse.position.x < 400))
		{
			_speedX = -SPEED_X;
			setScaleX(-1);
			play("walk");
		}
		
		if (GKeyboard.isRight || (GMouse.isPressed && GMouse.position.x >= 400))
		{
			_speedX = SPEED_X;
			setScaleX(1);
			play("walk");
		}
		
		if (!GKeyboard.isRight && !GKeyboard.isLeft && !GMouse.isPressed)
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
}