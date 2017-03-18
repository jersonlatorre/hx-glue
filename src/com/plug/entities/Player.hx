package com.plug.entities;

import com.glue.GEngine;
import com.glue.display.GMultipleSprite;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GSceneManager;
import com.glue.utils.GTime;
import com.glue.utils.GVector2D;
import motion.Actuate;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

enum State
{
	INIT;
	NORMAL;
}

class Player extends GMultipleSprite
{
	var IMPULSE:GVector2D = new GVector2D(0, -1.3);
	var GRAVITY:GVector2D = new GVector2D(0, 0.002);
	
	public var state:State = State.INIT;
	
	public function new() 
	{
		super();
		addAnimation("idle", "player_idle");
		setAnimation("idle");
		setAnchor(0.5, 1);
		setPosition(GEngine.width / 2, GEngine.height - 250);
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
				if (position.y + 10 >= GEngine.height - 250)
				{
					position.y = GEngine.height - 250;
					velocity = IMPULSE;
				}
				
				position.x += (GMouse.position.x - position.x) * 0.001 * GTime.deltaTime;
				
				velocity = GVector2D.add(velocity, GVector2D.scale(GRAVITY, GTime.deltaTime)); if (velocity.y >= 20) velocity.y = 20;
				position = GVector2D.add(position, GVector2D.scale(velocity, GTime.deltaTime));
			}
		}
		
		super.update();
	}
}