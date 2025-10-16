package platformer.entities;

import glue.display.Entity;
import openfl.display.Shape;

class Enemy extends Entity
{
	static inline final MOVE_SPEED:Float = 50;
	static inline final GRAVITY:Float = 800;

	public var direction:Float = -1;
	public var isDead:Bool = false;

	var sprite:Shape;

	public function new()
	{
		super();

		width = 32;
		height = 32;
		anchor.set(0.5, 1.0);

		sprite = new Shape();
		sprite.graphics.beginFill(0x8B0000);
		sprite.graphics.drawRect(0, 0, width, height);
		sprite.graphics.endFill();
		_skin.addChild(sprite);

		velocity.x = MOVE_SPEED * direction;
		bounds.setTo(-width/2, -height, width, height);
	}

	override public function update()
	{
		if (isDead) return;

		acceleration.y = GRAVITY;
		velocity.x = MOVE_SPEED * direction;
	}

	public function changeDirection()
	{
		direction *= -1;
	}

	public function die()
	{
		isDead = true;
		alpha = 0.5;
		velocity.set(0, 0);
		acceleration.set(0, 0);
	}
}
