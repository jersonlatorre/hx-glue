package com.glue.game;
import com.glue.entities.GEntity;
import com.glue.utils.GVector2D;

/**
 * ...
 * @author Uno
 */

@final class GCamera
{

	public var position:GVector2D = new GVector2D(0, 0);
	
	var _target:GEntity;
	
	static inline var STATE_TARGET:Int = 0;
	static inline var STATE_FOLLOW:Int = 1;
	static inline var STATE_FOLLOW_X:Int = 3;
	static inline var STATE_FOLLOW_Y:Int = 4;
	static inline var STATE_MANUAL:Int = 2;
	
	var _leftLimit:Float = Math.NEGATIVE_INFINITY;
	var _rightLimit:Float = Math.POSITIVE_INFINITY;
	var _topLimit:Float = Math.POSITIVE_INFINITY;
	var _bottomLimit:Float = Math.NEGATIVE_INFINITY;
	
	public var state:Int = STATE_MANUAL;
	
	public function new() 
	{
		
	}
	
	public function target(target:GEntity):Void 
	{
		_target = target;
		state = STATE_TARGET;
	}
	
	public function follow(target:GEntity):Void
	{
		_target = target;
		state = STATE_FOLLOW;
	}
	
	public function setLeftLimit(limit:Float):Void
	{
		_leftLimit = limit;
	}
	
	public function setRightLimit(limit:Float):Void
	{
		_rightLimit = limit;
	}
	
	public function setTopLimit(limit:Float):Void
	{
		_topLimit = limit;
	}
	
	public function setBottomLimit(limit:Float):Void
	{
		_bottomLimit = limit;
	}
	
	public function update():Void
	{
		switch(state)
		{
			case STATE_TARGET:
			{
				position.x = _target.position.x;
				position.y = _target.position.y;
			}
			
			case STATE_FOLLOW:
			{
				position.x += (_target.position.x - position.x) / 10;
				position.y += (_target.position.y - position.y) / 10;
			}
			
			case STATE_FOLLOW_X:
			{
				position.x += (_target.position.x - position.x) / 10;
			}
			
			case STATE_FOLLOW_Y:
			{
				position.y += (_target.position.y - position.y) / 10;
			}
			
			case STATE_MANUAL:
			{
				
			}
		}
		
		if (position.x < _leftLimit)
		{
			position.x = _leftLimit;
		}
		
		if (position.x > _rightLimit)
		{
			position.x = _rightLimit;
		}
		
		if (position.y < _bottomLimit)
		{
			position.y = _bottomLimit;
		}
		
		if (position.y > _topLimit)
		{
			position.y = _topLimit;
		}
	}
	
	public function destroy()
	{
		_target = null;
	}
}