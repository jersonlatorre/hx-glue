package glue.display;

import glue.style.Palette;
import openfl.display.Graphics;

/**
 * Visual primitive shapes with Glue styling.
 * Chainable API for quick prototyping.
 *
 * Usage:
 *   add(Shape.circle(32));
 *   add(Shape.box(64, 64).fill(Palette.CORAL));
 *   add(Shape.polygon(6, 48).stroke(Palette.SKY, 2));
 *   add(Shape.capsule(80, 32).fill(Palette.GRASS));
 */
class Shape extends Entity
{
	var _fillColor:Null<Int> = null;
	var _strokeColor:Null<Int> = null;
	var _strokeWidth:Float = 1;
	var _shapeType:ShapeType;
	var _params:ShapeParams;

	function new(type:ShapeType, params:ShapeParams)
	{
		_shapeType = type;
		_params = params;
		super();
	}

	override public function init():Void
	{
		// Default fill with palette color
		_fillColor = Palette.SKY;
		redraw();
	}

	/**
	 * Create a circle
	 */
	public static function circle(radius:Float):Shape
	{
		return new Shape(Circle, { radius: radius });
	}

	/**
	 * Create a rectangle/box
	 */
	public static function box(w:Float, h:Float):Shape
	{
		return new Shape(Box, { width: w, height: h });
	}

	/**
	 * Create a square
	 */
	public static function square(size:Float):Shape
	{
		return box(size, size);
	}

	/**
	 * Create a rounded rectangle
	 */
	public static function roundedBox(w:Float, h:Float, radius:Float):Shape
	{
		return new Shape(RoundedBox, { width: w, height: h, radius: radius });
	}

	/**
	 * Create a regular polygon (triangle, hexagon, etc.)
	 */
	public static function polygon(sides:Int, radius:Float):Shape
	{
		return new Shape(Polygon, { sides: sides, radius: radius });
	}

	/**
	 * Create a triangle
	 */
	public static function triangle(size:Float):Shape
	{
		return polygon(3, size);
	}

	/**
	 * Create a hexagon
	 */
	public static function hexagon(size:Float):Shape
	{
		return polygon(6, size);
	}

	/**
	 * Create a capsule (pill shape)
	 */
	public static function capsule(w:Float, h:Float):Shape
	{
		return new Shape(Capsule, { width: w, height: h });
	}

	/**
	 * Create a line
	 */
	public static function line(x1:Float, y1:Float, x2:Float, y2:Float, thickness:Float = 2):Shape
	{
		return new Shape(Line, { x1: x1, y1: y1, x2: x2, y2: y2, thickness: thickness });
	}

	/**
	 * Create a star
	 */
	public static function star(points:Int, outerRadius:Float, innerRadius:Float):Shape
	{
		return new Shape(Star, { points: points, outerRadius: outerRadius, innerRadius: innerRadius });
	}

	/**
	 * Create a cross/plus
	 */
	public static function cross(size:Float, thickness:Float):Shape
	{
		return new Shape(Cross, { size: size, thickness: thickness });
	}

	// Chainable styling methods

	/**
	 * Set fill color
	 */
	public function fill(color:Int):Shape
	{
		_fillColor = color;
		redraw();
		return this;
	}

	/**
	 * Remove fill
	 */
	public function noFill():Shape
	{
		_fillColor = null;
		redraw();
		return this;
	}

	/**
	 * Set stroke
	 */
	public function stroke(color:Int, width:Float = 2):Shape
	{
		_strokeColor = color;
		_strokeWidth = width;
		redraw();
		return this;
	}

	/**
	 * Remove stroke
	 */
	public function noStroke():Shape
	{
		_strokeColor = null;
		redraw();
		return this;
	}

	/**
	 * Set both fill and stroke
	 */
	public function style(fillColor:Int, strokeColor:Int, strokeWidth:Float = 2):Shape
	{
		_fillColor = fillColor;
		_strokeColor = strokeColor;
		_strokeWidth = strokeWidth;
		redraw();
		return this;
	}

	/**
	 * Center the anchor
	 */
	public function centered():Shape
	{
		anchor.set(0.5, 0.5);
		return this;
	}

	function redraw():Void
	{
		var g:Graphics = _skin.graphics;
		g.clear();

		// Apply stroke
		if (_strokeColor != null)
		{
			g.lineStyle(_strokeWidth, _strokeColor);
		}
		else
		{
			g.lineStyle();
		}

		// Apply fill
		if (_fillColor != null)
		{
			g.beginFill(_fillColor);
		}

		// Draw shape
		switch (_shapeType)
		{
			case Circle:
				var r = _params.radius;
				g.drawCircle(r, r, r);
				width = height = r * 2;

			case Box:
				g.drawRect(0, 0, _params.width, _params.height);
				width = _params.width;
				height = _params.height;

			case RoundedBox:
				g.drawRoundRect(0, 0, _params.width, _params.height, _params.radius);
				width = _params.width;
				height = _params.height;

			case Polygon:
				drawPolygon(g, _params.sides, _params.radius);
				width = height = _params.radius * 2;

			case Capsule:
				drawCapsule(g, _params.width, _params.height);
				width = _params.width;
				height = _params.height;

			case Line:
				if (_strokeColor == null) g.lineStyle(2, Palette.SKY);
				g.moveTo(_params.x1, _params.y1);
				g.lineTo(_params.x2, _params.y2);
				width = Math.abs(_params.x2 - _params.x1);
				height = Math.abs(_params.y2 - _params.y1);

			case Star:
				drawStar(g, _params.points, _params.outerRadius, _params.innerRadius);
				width = height = _params.outerRadius * 2;

			case Cross:
				drawCross(g, _params.size, _params.thickness);
				width = height = _params.size;
		}

		if (_fillColor != null)
		{
			g.endFill();
		}

		// Update bounds for collision
		bounds.width = width;
		bounds.height = height;
	}

	function drawPolygon(g:Graphics, sides:Int, radius:Float):Void
	{
		var cx = radius;
		var cy = radius;
		var angleStep = Math.PI * 2 / sides;
		var startAngle = -Math.PI / 2; // Start at top

		g.moveTo(cx + Math.cos(startAngle) * radius, cy + Math.sin(startAngle) * radius);

		for (i in 1...sides + 1)
		{
			var angle = startAngle + i * angleStep;
			g.lineTo(cx + Math.cos(angle) * radius, cy + Math.sin(angle) * radius);
		}
	}

	function drawCapsule(g:Graphics, w:Float, h:Float):Void
	{
		var radius = Math.min(w, h) / 2;

		if (w > h)
		{
			// Horizontal capsule
			g.drawRoundRect(0, 0, w, h, h, h);
		}
		else
		{
			// Vertical capsule
			g.drawRoundRect(0, 0, w, h, w, w);
		}
	}

	function drawStar(g:Graphics, points:Int, outer:Float, inner:Float):Void
	{
		var cx = outer;
		var cy = outer;
		var angleStep = Math.PI / points;
		var startAngle = -Math.PI / 2;

		g.moveTo(cx + Math.cos(startAngle) * outer, cy + Math.sin(startAngle) * outer);

		for (i in 1...points * 2 + 1)
		{
			var angle = startAngle + i * angleStep;
			var radius = (i % 2 == 0) ? outer : inner;
			g.lineTo(cx + Math.cos(angle) * radius, cy + Math.sin(angle) * radius);
		}
	}

	function drawCross(g:Graphics, size:Float, thickness:Float):Void
	{
		var half = size / 2;
		var t2 = thickness / 2;

		// Horizontal bar
		g.drawRect(0, half - t2, size, thickness);
		// Vertical bar
		g.drawRect(half - t2, 0, thickness, size);
	}
}

private enum ShapeType
{
	Circle;
	Box;
	RoundedBox;
	Polygon;
	Capsule;
	Line;
	Star;
	Cross;
}

private typedef ShapeParams =
{
	?radius:Float,
	?width:Float,
	?height:Float,
	?sides:Int,
	?x1:Float,
	?y1:Float,
	?x2:Float,
	?y2:Float,
	?thickness:Float,
	?points:Int,
	?outerRadius:Float,
	?innerRadius:Float,
	?size:Float
}
