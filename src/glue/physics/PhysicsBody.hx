package glue.physics;

import glue.math.Vector2D;
import glue.utils.Time;

/**
 * Optional physics component for entities.
 * Add to entities that need velocity/acceleration physics.
 *
 * Usage:
 *   class Player extends Entity {
 *       var physics:PhysicsBody;
 *       override function init() {
 *           physics = new PhysicsBody(position);
 *           physics.velocity.set(100, 0);
 *           physics.friction = 0.9;
 *       }
 *       override function update() {
 *           physics.update();
 *       }
 *   }
 */
class PhysicsBody
{
	public var velocity:Vector2D;
	public var acceleration:Vector2D;
	public var friction:Float = 1.0;
	public var maxSpeed:Float = 0; // 0 = no limit

	var position:Vector2D;

	public function new(position:Vector2D)
	{
		this.position = position;
		velocity = new Vector2D(0, 0);
		acceleration = new Vector2D(0, 0);
	}

	public function update():Void
	{
		velocity += acceleration * Time.deltaTime;

		if (friction < 1.0)
		{
			velocity *= friction;
		}

		if (maxSpeed > 0)
		{
			var speed = velocity.length;
			if (speed > maxSpeed)
			{
				velocity = velocity.normalized * maxSpeed;
			}
		}

		position += velocity * Time.deltaTime;
	}

	public function applyForce(force:Vector2D):Void
	{
		acceleration += force;
	}

	public function applyImpulse(impulse:Vector2D):Void
	{
		velocity += impulse;
	}

	public function stop():Void
	{
		velocity.set(0, 0);
		acceleration.set(0, 0);
	}
}
