package demo.entities;

import glue.Glue;
import glue.display.Entity;
import glue.input.Input;
import openfl.display.Shape;

class Player extends Entity
{
	static inline var SPEED:Float = 320;

	var body:Shape;

	public function new()
	{
		super();

		width = 60;
		height = 40;
		anchor.set(0.5, 0.5);

		body = new Shape();
		body.graphics.beginFill(0x3FA9F5);
		body.graphics.drawRoundRect(0, 0, width, height, 18, 18);
		body.graphics.endFill();
		_skin.addChild(body);

		bounds.setTo(-width * anchor.x, -height * anchor.y, width, height);
	}

	override public function update()
	{
		var horizontal:Float = 0;
		if (Input.isKeyPressed("move_left")) horizontal -= 1;
		if (Input.isKeyPressed("move_right")) horizontal += 1;

		velocity.x = SPEED * horizontal;
		velocity.y = 0;
		acceleration.set(0, 0);

		if (horizontal == 0)
		{
			velocity.x = 0;
		}

		var halfWidth = width * 0.5;
		var minX = halfWidth;
		var maxX = Glue.width - halfWidth;
		if (position.x < minX) position.x = minX;
		if (position.x > maxX) position.x = maxX;
	}
}
