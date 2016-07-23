package com.glue.game;
import com.glue.display.GEntity;
import com.glue.utils.GVector2D;

/**
 * ...
 * @author Uno
 */

@final class GCamera
{

	public var position:GVector2D;
	
	var _target:GEntity;
	
	static inline var STATE_FOLLOW:Int = 1;
	static inline var STATE_FOLLOW_X:Int = 3;
	static inline var STATE_FOLLOW_Y:Int = 4;
	static inline var STATE_NONE:Int = 2;
	
	var _leftLimit:Float = Math.NEGATIVE_INFINITY;
	var _rightLimit:Float = Math.POSITIVE_INFINITY;
	var _topLimit:Float = Math.POSITIVE_INFINITY;
	var _bottomLimit:Float = Math.NEGATIVE_INFINITY;
	var _mode:Int = STATE_NONE;
	var _delayFactor:Float = 0.1;
	
	public function new() 
	{
		position = GVector2D.create(GEngine.width / 2, -GEngine.height / 2);
	}
	
	public function follow(target:GEntity, delayFactor:Float = 0.1):GCamera
	{
		_target = target;
		_delayFactor = delayFactor;
		_mode = STATE_FOLLOW;
		return this;
	}
	
	public function setPosition(x:Float, y:Float):GCamera
	{
		position.x = x;
		position.y = y;
		return this;
	}
	
	public function setPositionX(x:Float):GCamera
	{
		position.x = x;
		return this;
	}
	
	public function setPositionY(y:Float):GCamera
	{
		position.y = y;
		return this;
	}
	
	public function setLeftLimit(limit:Float):GCamera
	{
		_leftLimit = limit;
		return this;
	}
	
	public function setRightLimit(limit:Float):GCamera
	{
		_rightLimit = limit;
		return this;
	}
	
	public function setTopLimit(limit:Float):GCamera
	{
		_topLimit = limit;
		return this;
	}
	
	public function setBottomLimit(limit:Float):GCamera
	{
		_bottomLimit = limit;
		return this;
	}
	
	public function update():Void
	{
		switch(_mode)
		{
			case STATE_FOLLOW:
			{
				position.x += (_target.position.x - position.x) * _delayFactor;
				position.y += (_target.position.y - position.y) * _delayFactor;
			}
			
			case STATE_FOLLOW_X:
			{
				position.x += (_target.position.x - position.x) * _delayFactor;
			}
			
			case STATE_FOLLOW_Y:
			{
				position.y += (_target.position.y - position.y) * _delayFactor;
			}
			
			case STATE_NONE:
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