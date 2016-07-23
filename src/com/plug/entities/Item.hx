package com.plug.entities;
	
import com.glue.entities.GAlignMode;
import com.glue.entities.GSprite;
import com.plug.entities.Player;
import com.glue.utils.GTime;
import openfl.display.Sprite;

/**
 * ...
 * @author wara
 */
class Item extends GSprite 
{
	private var _speedY:Float;
	public var type:String;
	public var isDying:Bool = false;
	public var isDead:Bool = false;
	public var index:Int;
	static public var count:Int = 0;
	
	static public inline var STATE_ALIVE:Int = 0;
	static public inline var STATE_DIYING:Int = 1;
	static public inline var STATE_DEAD:Int = 2;
	
	public var state:Int;
	
	public function new(type:String) 
	{
		super(GAlignMode.CENTER);
		
		state = STATE_ALIVE;
		
		this.type = type;
		
		if (Math.random() < 0.3333)
		{
			_speedY = 10 / 15;
		}
		else if (Math.random() < 0.6666)
		{
			_speedY = 12 / 15;
		}
		else
		{
			_speedY = 14 / 15;
		}
		
		if (type == "bad")
		{
			setBounds(-17, 17, 34, 34);
			_speedY *= 1.5;
		}
		else
		{
			setBounds(-20, 20, 40, 40);
			_speedY *= 1.2;
		}
		
		
		
		_speedY *= -0.4;
		
		var r:Float = Math.random();
		var n:String;
		
		if (r < 0.33)
		{
			n = "1";
		}
		else if (r < 0.66)
		{
			n = "2";
		}
		else
		{
			n = "3";
		}
		
		addAnimation("stand", "item_" + type + "_" + n +  "_stand");
		addAnimation("hit", "item_" + type + "_" + n +  "_die");
		setAnimation("stand");
		
		position.x = Math.random() * 680 + 60 - 400;
		position.y = 650;
	}
	
	override public function update():Void 
	{
		switch(state)
		{
			case STATE_ALIVE:
			{
				position.y += _speedY * 16;
				super.update();
				
				if (position.y < -60)
				{
					state = STATE_DEAD;
				}
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
	
	override public function onEndAnimation():Void 
	{
		if (animation == "hit")
		{
			//trace("dead: " + index);
			state = STATE_DEAD;
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	public function hit() 
	{
		state = STATE_DIYING;
		setAnimation("hit");
	}
}