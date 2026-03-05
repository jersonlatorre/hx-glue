package glue.physics;

import glue.display.Entity;
import glue.math.Vector2D;
import glue.style.Palette;

#if nape
import nape.geom.Vec2;
import nape.space.Space;
import nape.util.ShapeDebug;
import nape.phys.Body as NapeBody;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionCallback;
#end

import openfl.display.Sprite;

/**
 * Physics world - simplified Nape Space wrapper.
 *
 * Usage:
 *   var world = new World();
 *   world.gravity(0, 600);
 *
 *   // In update:
 *   world.step();
 *
 *   // Debug draw:
 *   world.debugDraw(canvas);
 *
 * Requires: haxelib install nape-haxe4
 */
class World
{
	#if nape
	public var space:Space;

	var _bodies:Array<Body> = [];
	var _debugDraw:ShapeDebug;
	var _debugSprite:Sprite;

	public function new(?gravityX:Float = 0, ?gravityY:Float = 980)
	{
		space = new Space(Vec2.weak(gravityX, gravityY));
	}

	/**
	 * Set gravity
	 */
	public function gravity(x:Float, y:Float):World
	{
		space.gravity.setxy(x, y);
		return this;
	}

	/**
	 * Step the simulation
	 */
	public function step(?dt:Float):Void
	{
		var delta = dt != null ? dt : 1 / 60;
		space.step(delta);

		// Sync all tracked bodies
		for (body in _bodies)
		{
			body.sync();
		}
	}

	/**
	 * Add a body and track it for auto-sync
	 */
	public function add(body:Body):Body
	{
		_bodies.push(body);
		return body;
	}

	/**
	 * Remove a body
	 */
	public function remove(body:Body):Void
	{
		body.remove();
		_bodies.remove(body);
	}

	/**
	 * Create and add a static ground platform
	 */
	public function addGround(x:Float, y:Float, width:Float, height:Float):Body
	{
		var body = Body.fixed().box(width, height).at(x + width / 2, y + height / 2).addTo(this);
		return body;
	}

	/**
	 * Create walls around a rectangle (for keeping things in bounds)
	 */
	public function addBounds(x:Float, y:Float, width:Float, height:Float, thickness:Float = 32):World
	{
		// Left
		Body.fixed().box(thickness, height).at(x - thickness / 2, y + height / 2).addTo(this);
		// Right
		Body.fixed().box(thickness, height).at(x + width + thickness / 2, y + height / 2).addTo(this);
		// Top
		Body.fixed().box(width + thickness * 2, thickness).at(x + width / 2, y - thickness / 2).addTo(this);
		// Bottom
		Body.fixed().box(width + thickness * 2, thickness).at(x + width / 2, y + height + thickness / 2).addTo(this);

		return this;
	}

	/**
	 * Enable debug drawing
	 */
	public function debugDraw(canvas:Sprite):World
	{
		if (_debugDraw == null)
		{
			_debugDraw = new ShapeDebug(800, 600);
			_debugDraw.drawConstraints = true;
			_debugDraw.drawBodies = true;
			_debugSprite = _debugDraw.display;
			canvas.addChild(_debugSprite);
		}

		_debugDraw.clear();
		_debugDraw.draw(space);
		_debugDraw.flush();

		return this;
	}

	/**
	 * Disable debug drawing
	 */
	public function hideDebug():Void
	{
		if (_debugSprite != null && _debugSprite.parent != null)
		{
			_debugSprite.parent.removeChild(_debugSprite);
		}
		_debugDraw = null;
		_debugSprite = null;
	}

	/**
	 * Query bodies at a point
	 */
	public function bodiesAt(x:Float, y:Float):Array<Body>
	{
		var result:Array<Body> = [];
		var bodies = space.bodiesUnderPoint(Vec2.weak(x, y));

		for (napeBody in bodies)
		{
			for (body in _bodies)
			{
				if (body.nape == napeBody)
				{
					result.push(body);
					break;
				}
			}
		}

		return result;
	}

	/**
	 * Raycast - returns first hit
	 */
	public function raycast(startX:Float, startY:Float, endX:Float, endY:Float):Null<RayHit>
	{
		var ray = nape.geom.Ray.fromSegment(Vec2.weak(startX, startY), Vec2.weak(endX, endY));
		var result = space.rayCast(ray);

		if (result != null)
		{
			return {
				x: result.position.x,
				y: result.position.y,
				normalX: result.normal.x,
				normalY: result.normal.y,
				distance: result.distance
			};
		}

		return null;
	}

	/**
	 * Clear all bodies
	 */
	public function clear():Void
	{
		space.clear();
		_bodies = [];
	}

	#else
	// Stubs when Nape not available
	public function new(?gravityX:Float = 0, ?gravityY:Float = 980) {}
	public function gravity(x:Float, y:Float):World return this;
	public function step(?dt:Float):Void {}
	public function add(body:Body):Body return body;
	public function remove(body:Body):Void {}
	public function addGround(x:Float, y:Float, width:Float, height:Float):Body return Body.fixed();
	public function addBounds(x:Float, y:Float, width:Float, height:Float, thickness:Float = 32):World return this;
	public function debugDraw(canvas:Sprite):World return this;
	public function hideDebug():Void {}
	public function bodiesAt(x:Float, y:Float):Array<Body> return [];
	public function raycast(startX:Float, startY:Float, endX:Float, endY:Float):Null<RayHit> return null;
	public function clear():Void {}
	#end
}

typedef RayHit =
{
	x:Float,
	y:Float,
	normalX:Float,
	normalY:Float,
	distance:Float
}
