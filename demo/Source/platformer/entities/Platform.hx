package platformer.entities;

import glue.display.Entity;
import openfl.display.Shape;

class Platform extends Entity
{
	public function new(w:Float, h:Float, color:Int = 0x8B4513)
	{
		super();

		width = w;
		height = h;

		var sprite = new Shape();
		sprite.graphics.beginFill(color);
		sprite.graphics.drawRect(0, 0, w, h);
		sprite.graphics.endFill();
		_skin.addChild(sprite);

		bounds.setTo(0, 0, w, h);
	}

	public function getTop():Float
	{
		return position.y;
	}

	public function getBottom():Float
	{
		return position.y + height;
	}

	public function getLeft():Float
	{
		return position.x;
	}

	public function getRight():Float
	{
		return position.x + width;
	}

	public function containsPoint(x:Float, y:Float):Bool
	{
		return x >= getLeft() && x <= getRight() && y >= getTop() && y <= getBottom();
	}
}
