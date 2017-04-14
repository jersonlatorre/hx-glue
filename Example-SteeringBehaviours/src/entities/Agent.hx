package entities;

import glue.Glue;
import glue.utils.GTime;
import glue.display.GEntity;
import glue.math.GVector2D;

/**
 * ...
 * @author Jerson La Torre
 */

class Agent extends GEntity
{
	var _target:Target;

	var _velocity:GVector2D = new GVector2D();
	var _desired:GVector2D = new GVector2D();
	var _steer:GVector2D = new GVector2D();

	static inline var MAX_SPEED:Float = 200;
	static inline var MAX_FORCE:Float = 200;

	override public function init()
	{
		createRectangleGraphic(50, 25, 0x0000FF);
		setAnchor(0.5, 0.5);
		setPosition(Glue.width / 2, Glue.height / 2);
	}

	override public function update()
	{
		_desired = (_target.position - position).scaledTo(MAX_SPEED);
		_steer = (_desired - _velocity).truncate(MAX_FORCE);

		_velocity += _steer * GTime.deltaTime;
		_velocity.truncate(MAX_SPEED);
		position += _velocity * GTime.deltaTime;

		setRotation(_velocity.angle());
	}

	public function setTarget(target:Target)
	{
		_target = target;
	}
}