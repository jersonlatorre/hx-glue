package demo.entities;

import glue.display.GEntity;
import openfl.display.Shape;

class FallingItem extends GEntity
{
	static inline var MIN_SPEED:Float = 120;
	static inline var MAX_EXTRA_SPEED:Float = 160;

	var speed:Float;
	var sprite:Shape;

	public function new()
	{
		super();

		width = 30;
		height = 30;
		anchor.set(0.5, 0.5);

		sprite = new Shape();
		sprite.graphics.beginFill(randomColor());
		sprite.graphics.drawCircle(width * 0.5, height * 0.5, width * 0.5);
		sprite.graphics.endFill();
		_skin.addChild(sprite);

		bounds.setTo(-width * anchor.x, -height * anchor.y, width, height);

		speed = MIN_SPEED + Math.random() * MAX_EXTRA_SPEED;
	}

	override public function update()
	{
		velocity.set(0, speed);
		acceleration.set(0, 0);
	}

	function randomColor():UInt
	{
		var hue = Std.int(Math.random() * 360);
		var saturation = 0.6 + Math.random() * 0.4;
		var value = 0.75 + Math.random() * 0.25;
		return hsvToRgb(hue, saturation, value);
	}

	function hsvToRgb(h:Float, s:Float, v:Float):UInt
	{
		var c = v * s;
		var x = c * (1 - Math.abs((h / 60) % 2 - 1));
		var m = v - c;
		var r:Float = 0;
		var g:Float = 0;
		var b:Float = 0;

		if (0 <= h && h < 60)      { r = c; g = x; b = 0; }
		else if (60 <= h && h < 120)  { r = x; g = c; b = 0; }
		else if (120 <= h && h < 180) { r = 0; g = c; b = x; }
		else if (180 <= h && h < 240) { r = 0; g = x; b = c; }
		else if (240 <= h && h < 300) { r = x; g = 0; b = c; }
		else                          { r = c; g = 0; b = x; }

		var red = Std.int((r + m) * 255);
		var green = Std.int((g + m) * 255);
		var blue = Std.int((b + m) * 255);
		return (0xFF << 24) | (red << 16) | (green << 8) | blue;
	}
}
