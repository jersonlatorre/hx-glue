package example2.entities;

import glue.Glue;
import glue.display.GSprite;
import glue.input.GMouse;
import glue.utils.GTime;
import glue.utils.GVector2D;

/**
 * ...
 * @author Jerson La Torre
 */

enum State
{
	INIT;
	NORMAL;
}

class Player extends GSprite
{
	var IMPULSE:GVector2D = new GVector2D(0, -1.3);
	var GRAVITY:GVector2D = new GVector2D(0, 0.002);
	
	public var state:State = State.INIT;
	
	public function new() 
	{
		super();
		addAnimation("idle", "player_idle");
		play("idle");
		setAnchor(0.5, 1);
		setPosition(Glue.width / 2, Glue.height - 250);
	}
	
	override public function update():Void
	{
		switch (state)
		{
			case State.INIT:
			{
				if (GMouse.isDown)
				{
					velocity = IMPULSE;
					state = State.NORMAL;
				}
			}
			
			case State.NORMAL:
			{
				if (position.y + 10 >= Glue.height - 250)
				{
					position.y = Glue.height - 250;
					velocity = IMPULSE;
				}
				
				position.x += (GMouse.position.x - position.x) * 0.001 * GTime.deltaTime;
				
				velocity += GRAVITY * GTime.deltaTime;
				
				if (velocity.y >= 20) velocity.y = 20;

				position += velocity * GTime.deltaTime;
			}
		}
		
		super.update();
	}
}