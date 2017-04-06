package glue.game;

import glue.display.GEntity;
import glue.utils.GVector2D;

/**
 * ...
 * @author Jerson La Torre
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
	var _topLimit:Float = Math.NEGATIVE_INFINITY;
	var _bottomLimit:Float = Math.POSITIVE_INFINITY;
	var _mode:Int = STATE_NONE;
	var _delayFactor:Float = 0.1;
	
	public function new() 
	{
		position = GVector2D.create(Glue.width / 2, Glue.height / 2);
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
				position.x += Std.int((_target.position.x - position.x) * _delayFactor);
				position.y += Std.int((_target.position.y - position.y) * _delayFactor);
			}
			
			case STATE_FOLLOW_X:
			{
				position.x += Std.int((_target.position.x - position.x) * _delayFactor);
			}
			
			case STATE_FOLLOW_Y:
			{
				position.y += Std.int((_target.position.y - position.y) * _delayFactor);
			}
			
			case STATE_NONE:
			{
				
			}
		}

		if (position.x > _rightLimit - Glue.width / 2)
		{
			position.x = _rightLimit - Glue.width / 2;
		}
		
		if (position.x < _leftLimit + Glue.width / 2)
		{
			position.x = _leftLimit + Glue.width / 2;
		}
		
		if (position.y > _bottomLimit - Glue.height / 2)
		{
			position.y = _bottomLimit - Glue.height / 2;
		}
		
		if ( position.y < _topLimit + Glue.height / 2)
		{
			position.y = _topLimit + Glue.height / 2;
		}
	}
	
	public function destroy()
	{
		_target = null;
	}
}