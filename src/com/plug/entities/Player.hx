package com.plug.entities;

import com.glue.display.GMultipleSprite;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GSceneManager;
import com.glue.utils.GTime;
import motion.Actuate;
import openfl.display.Sprite;

/**
 * ...
 * @author Uno
 */

class Player extends GMultipleSprite
{
	static public inline var STATE_ALIVE:Int = 0;
	static public inline var STATE_DIYING:Int = 1;
	static public inline var STATE_DEAD:Int = 2;
	
	static inline private var SPEED_X:Float = 0.6;
	
	public var state:Int;
	
	var _speedX:Float;
	
	public function new() 
	{
		super("world");
		addAnimation("stand", "Anim");
		setAnimation("stand");
		
		state = STATE_ALIVE;
		
		//setBounds(-18, 80, 36, 80);
	}
	
	override public function update():Void 
	{
		switch(state)
		{
			case STATE_ALIVE:
			{
				//if (GKeyboard.isLeft || (GMouse.isPressed && Global.scene.mouseX < 0))
				//{
					//_speedX = -SPEED_X;
					//setScaleX(-1);
					//setAnimation("walk");
				//}
				//
				//if (GKeyboard.isRight || (GMouse.isPressed && Global.scene.mouseX >= 0))
				//{
					//_speedX = SPEED_X;
					//setScaleX(1);
					//setAnimation("walk");
				//}
				//
				//if (!GKeyboard.isRight && !GKeyboard.isLeft && !GMouse.isPressed)
				//{
					//_speedX = 0;
					//setAnimation("stand");
				//}
				//
				//position.x += _speedX * GTime.dt;
				//
				//if (position.x >= 400 - 30)
				//{
					//position.x = 400 - 30;
				//}
				//
				//if (position.x <= -400 + 30)
				//{
					//position.x = -400 + 30;
				//}
				
				super.update();
			}
			
			case STATE_DIYING:
			{
				super.update();
			}
			
			case STATE_DEAD:
			{
				
			}
		}
	}
}