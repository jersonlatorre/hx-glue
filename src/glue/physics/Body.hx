package glue.physics;

import glue.display.Entity;
import glue.math.Vector2D;

#if nape
import nape.geom.Vec2;
import nape.phys.Body as NapeBody;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
#end

/**
 * Simplified physics body wrapper for Nape.
 * Syncs automatically with Entity position/rotation.
 *
 * Usage:
 *   // In your scene
 *   var world = new World();
 *
 *   // Create physics body
 *   var player = add(new Player());
 *   player.body = Body.dynamic().circle(16).at(100, 100).addTo(world);
 *
 *   // In update
 *   world.step();
 *
 * Requires: haxelib install nape-haxe4
 */
class Body
{
	#if nape
	public var nape:NapeBody;
	var _entity:Entity;
	var _world:World;

	// Shape builders
	var _pendingShapes:Array<PendingShape> = [];
	var _position:Vector2D = new Vector2D(0, 0);
	var _bodyType:BodyType = BodyType.DYNAMIC;
	var _material:Material;

	function new(type:BodyType)
	{
		_bodyType = type;
		_material = Material.wood();
	}

	// Factory methods

	/**
	 * Create a dynamic body (affected by forces)
	 */
	public static function dynamic():Body
	{
		return new Body(BodyType.DYNAMIC);
	}

	/**
	 * Create a static body (immovable)
	 */
	public static function fixed():Body
	{
		return new Body(BodyType.STATIC);
	}

	/**
	 * Create a kinematic body (moved by code, affects others)
	 */
	public static function kinematic():Body
	{
		return new Body(BodyType.KINEMATIC);
	}

	// Shape methods (chainable)

	/**
	 * Add circle shape
	 */
	public function circle(radius:Float, ?offsetX:Float = 0, ?offsetY:Float = 0):Body
	{
		_pendingShapes.push({ type: ShapeCircle, radius: radius, offsetX: offsetX, offsetY: offsetY });
		return this;
	}

	/**
	 * Add box shape
	 */
	public function box(width:Float, height:Float, ?offsetX:Float = 0, ?offsetY:Float = 0):Body
	{
		_pendingShapes.push({ type: ShapeBox, width: width, height: height, offsetX: offsetX, offsetY: offsetY });
		return this;
	}

	/**
	 * Add polygon shape from vertices
	 */
	public function polygon(vertices:Array<Vector2D>):Body
	{
		_pendingShapes.push({ type: ShapePolygon, vertices: vertices });
		return this;
	}

	// Property methods (chainable)

	/**
	 * Set initial position
	 */
	public function at(x:Float, y:Float):Body
	{
		_position.set(x, y);
		return this;
	}

	/**
	 * Set material properties
	 */
	public function material(elasticity:Float, friction:Float, density:Float = 1):Body
	{
		_material = new Material(elasticity, friction, density, density, 0.001);
		return this;
	}

	/**
	 * Use bouncy material
	 */
	public function bouncy():Body
	{
		_material = Material.rubber();
		return this;
	}

	/**
	 * Use slippery material
	 */
	public function slippery():Body
	{
		_material = Material.ice();
		return this;
	}

	/**
	 * Use heavy material
	 */
	public function heavy():Body
	{
		_material = Material.steel();
		return this;
	}

	/**
	 * Attach to entity and add to world
	 */
	public function addTo(world:World, ?entity:Entity):Body
	{
		_world = world;
		_entity = entity;

		// Build the Nape body
		nape = new NapeBody(_bodyType);
		nape.position.setxy(_position.x, _position.y);

		// Add shapes
		for (shape in _pendingShapes)
		{
			switch (shape.type)
			{
				case ShapeCircle:
					var c = new Circle(shape.radius, Vec2.weak(shape.offsetX, shape.offsetY), _material);
					nape.shapes.add(c);

				case ShapeBox:
					var p = Polygon.box(shape.width, shape.height, _material);
					p.translate(Vec2.weak(shape.offsetX, shape.offsetY));
					nape.shapes.add(p);

				case ShapePolygon:
					var verts:Array<Vec2> = [];
					for (v in shape.vertices)
					{
						verts.push(Vec2.weak(v.x, v.y));
					}
					var p = new Polygon(verts, _material);
					nape.shapes.add(p);
			}
		}

		nape.space = world.space;
		_pendingShapes = [];

		return this;
	}

	// Runtime methods

	/**
	 * Sync entity position/rotation from physics
	 */
	public function sync():Void
	{
		if (_entity != null && nape != null)
		{
			_entity.position.x = nape.position.x;
			_entity.position.y = nape.position.y;
			_entity.rotation = nape.rotation;
		}
	}

	/**
	 * Apply force
	 */
	public function push(fx:Float, fy:Float):Void
	{
		if (nape != null)
		{
			nape.applyImpulse(Vec2.weak(fx, fy));
		}
	}

	/**
	 * Apply force at point
	 */
	public function pushAt(fx:Float, fy:Float, px:Float, py:Float):Void
	{
		if (nape != null)
		{
			nape.applyImpulse(Vec2.weak(fx, fy), Vec2.weak(px, py));
		}
	}

	/**
	 * Set velocity directly
	 */
	public function setVelocity(vx:Float, vy:Float):Void
	{
		if (nape != null)
		{
			nape.velocity.setxy(vx, vy);
		}
	}

	/**
	 * Get velocity
	 */
	public function getVelocity():Vector2D
	{
		if (nape != null)
		{
			return new Vector2D(nape.velocity.x, nape.velocity.y);
		}
		return new Vector2D(0, 0);
	}

	/**
	 * Set position directly
	 */
	public function setPosition(x:Float, y:Float):Void
	{
		if (nape != null)
		{
			nape.position.setxy(x, y);
		}
	}

	/**
	 * Remove from world
	 */
	public function remove():Void
	{
		if (nape != null && nape.space != null)
		{
			nape.space = null;
		}
	}

	#else
	// Stub when Nape is not available
	public static function dynamic():Body return new Body();
	public static function fixed():Body return new Body();
	public static function kinematic():Body return new Body();

	public function circle(radius:Float, ?offsetX:Float, ?offsetY:Float):Body return this;
	public function box(width:Float, height:Float, ?offsetX:Float, ?offsetY:Float):Body return this;
	public function polygon(vertices:Array<Vector2D>):Body return this;
	public function at(x:Float, y:Float):Body return this;
	public function material(e:Float, f:Float, d:Float = 1):Body return this;
	public function bouncy():Body return this;
	public function slippery():Body return this;
	public function heavy():Body return this;
	public function addTo(world:World, ?entity:Entity):Body return this;
	public function sync():Void {}
	public function push(fx:Float, fy:Float):Void {}
	public function pushAt(fx:Float, fy:Float, px:Float, py:Float):Void {}
	public function setVelocity(vx:Float, vy:Float):Void {}
	public function getVelocity():Vector2D return new Vector2D(0, 0);
	public function setPosition(x:Float, y:Float):Void {}
	public function remove():Void {}
	#end
}

#if nape
private enum ShapeKind
{
	ShapeCircle;
	ShapeBox;
	ShapePolygon;
}

private typedef PendingShape =
{
	type:ShapeKind,
	?radius:Float,
	?width:Float,
	?height:Float,
	?offsetX:Float,
	?offsetY:Float,
	?vertices:Array<Vector2D>
}
#end
