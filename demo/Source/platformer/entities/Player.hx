package platformer.entities;

import glue.display.GEntity;
import openfl.display.Shape;

class Player extends GEntity
{
	static inline final MOVE_SPEED:Float = 200;
	static inline final JUMP_FORCE:Float = -400;
	static inline final GRAVITY:Float = 1200;
	static inline final MAX_FALL_SPEED:Float = 600;

	public var isOnGround:Bool = false;

	var sprite:Shape;

	public function new()
	{
		super();

		width = 32;
		height = 48;
		anchor.set(0.5, 1.0);

		sprite = new Shape();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, width, height);
		sprite.graphics.endFill();
		_skin.addChild(sprite);
	}

	override public function update()
	{
		handleInput();
		applyGravity();
		constrainVelocity();
	}

	function handleInput()
	{
		var moveX = 0.0;

		if (isPressed("left")) moveX = -1;
		if (isPressed("right")) moveX = 1;

		velocity.x = moveX * MOVE_SPEED;

		if (isDown("jump") && isOnGround)
		{
			velocity.y = JUMP_FORCE;
			isOnGround = false;
		}
	}

	function applyGravity()
	{
		if (!isOnGround)
		{
			acceleration.y = GRAVITY;
		}
		else
		{
			acceleration.y = 0;
			velocity.y = 0;
		}
	}

	function constrainVelocity()
	{
		if (velocity.y > MAX_FALL_SPEED)
		{
			velocity.y = MAX_FALL_SPEED;
		}
	}

	public function landOnGround(groundY:Float)
	{
		position.y = groundY;
		velocity.y = 0;
		acceleration.y = 0;
		isOnGround = true;
	}
}
