package glue.scene;

import glue.display.GEntity;
import glue.math.GVector2D;

/**
 * ...
 * @author Jerson La Torre
 */

@:final class GCamera
{

	public var position:GVector2D;
	
	var _target:GEntity;
	
	static inline var STATE_FOLLOW:Int = 1;
	static inline var STATE_FOLLOW_X:Int = 3;
	static inline var STATE_FOLLOW_Y:Int = 4;
	static inline var STATE_NONE:Int = 2;
	
	var _leftLimit:Int = -2147483647;
	var _rightLimit:Int = 2147483647;
	var _topLimit:Int = -2147483647;
	var _bottomLimit:Int = 2147483647;
	var _mode:Int = STATE_NONE;
	var _delayFactor:Float = 0.1;
	
	public function new() 
	{
		position = GVector2D.create(Glue.width * 0.5, Glue.height * 0.5);
	}
	
	public function follow(target:GEntity, delayFactor:Float = 0.1)
	{
		_target = target;
		_delayFactor = delayFactor;
		_mode = STATE_FOLLOW;
	}
	
	public function setPosition(x:Float, y:Float)
	{
		position.x = x;
		position.y = y;
	}
	
	public function setPositionX(x:Float)
	{
		position.x = x;
	}
	
	public function setPositionY(y:Float)
	{
		position.y = y;
	}
	
	public function setLeftLimit(limit:Int)
	{
		_leftLimit = limit;
	}
	
	public function setRightLimit(limit:Int)
	{
		_rightLimit = limit;
	}
	
	public function setTopLimit(limit:Int)
	{
		_topLimit = limit;
	}
	
	public function setBottomLimit(limit:Int)
	{
		_bottomLimit = limit;
	}
	
	public function update()
	{
		var halfWidth = Glue.width >> 1;
		var halfHeight = Glue.height >> 1;

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

		if (position.x > _rightLimit - halfWidth)
		{
			position.x = _rightLimit - halfWidth;
		}
		
		if (position.x < _leftLimit + halfWidth)
		{
			position.x = _leftLimit + halfWidth;
		}
		
		if (position.y > _bottomLimit - halfHeight)
		{
			position.y = _bottomLimit - halfHeight;
		}
		
		if ( position.y < _topLimit + halfHeight)
		{
			position.y = _topLimit + halfHeight;
		}
	}
	
	public function destroy()
	{
		_target = null;
	}
}
