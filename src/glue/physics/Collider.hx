package glue.physics;

import glue.display.Entity;
import glue.math.Vector2D;
import openfl.geom.Rectangle;

/**
 * Collision detection utilities.
 * Can be used standalone or attached to entities.
 */
class Collider
{
	public var bounds:Rectangle;
	public var offset:Vector2D;

	var entity:Entity;

	public function new(?entity:Entity, ?width:Float = 0, ?height:Float = 0)
	{
		this.entity = entity;
		this.offset = new Vector2D(0, 0);
		this.bounds = new Rectangle(0, 0, width, height);
	}

	public function setSize(width:Float, height:Float):Collider
	{
		bounds.width = width;
		bounds.height = height;
		return this;
	}

	public function setOffset(x:Float, y:Float):Collider
	{
		offset.set(x, y);
		return this;
	}

	public function getWorldBounds():Rectangle
	{
		if (entity != null)
		{
			return new Rectangle(
				entity.position.x + offset.x + bounds.x,
				entity.position.y + offset.y + bounds.y,
				bounds.width,
				bounds.height
			);
		}
		return bounds;
	}

	public function overlaps(other:Collider):Bool
	{
		var a = getWorldBounds();
		var b = other.getWorldBounds();

		return !(b.x > a.x + a.width
			|| b.x + b.width < a.x
			|| b.y > a.y + a.height
			|| b.y + b.height < a.y);
	}

	public function overlapsPoint(x:Float, y:Float):Bool
	{
		var b = getWorldBounds();
		return x >= b.x && x <= b.x + b.width && y >= b.y && y <= b.y + b.height;
	}

	public function overlapsRect(rect:Rectangle):Bool
	{
		var b = getWorldBounds();
		return !(rect.x > b.x + b.width
			|| rect.x + rect.width < b.x
			|| rect.y > b.y + b.height
			|| rect.y + rect.height < b.y);
	}

	/**
	 * Returns the overlap rectangle between this collider and another.
	 * Returns null if no overlap.
	 */
	public function getOverlap(other:Collider):Null<Rectangle>
	{
		var a = getWorldBounds();
		var b = other.getWorldBounds();

		var x1 = Math.max(a.x, b.x);
		var y1 = Math.max(a.y, b.y);
		var x2 = Math.min(a.x + a.width, b.x + b.width);
		var y2 = Math.min(a.y + a.height, b.y + b.height);

		if (x2 > x1 && y2 > y1)
		{
			return new Rectangle(x1, y1, x2 - x1, y2 - y1);
		}
		return null;
	}

	/**
	 * Returns the minimum translation vector to resolve collision.
	 * Returns null if no overlap.
	 */
	public function getMTV(other:Collider):Null<Vector2D>
	{
		var a = getWorldBounds();
		var b = other.getWorldBounds();

		var overlapX = Math.min(a.x + a.width, b.x + b.width) - Math.max(a.x, b.x);
		var overlapY = Math.min(a.y + a.height, b.y + b.height) - Math.max(a.y, b.y);

		if (overlapX <= 0 || overlapY <= 0)
		{
			return null;
		}

		if (overlapX < overlapY)
		{
			var sign = (a.x + a.width / 2 < b.x + b.width / 2) ? -1 : 1;
			return new Vector2D(overlapX * sign, 0);
		}
		else
		{
			var sign = (a.y + a.height / 2 < b.y + b.height / 2) ? -1 : 1;
			return new Vector2D(0, overlapY * sign);
		}
	}
}
