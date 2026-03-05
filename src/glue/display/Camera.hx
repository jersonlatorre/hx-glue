package glue.display;

import glue.Glue;
import glue.math.Vector2D;
import glue.utils.Time;
import openfl.display.Sprite;

/**
 * Camera with shake, follow, zoom and bounds.
 *
 * Usage:
 *   var camera = new Camera();
 *   camera.follow(player);
 *   camera.shake(0.5, 10);
 *   camera.zoom = 2;
 *
 *   // In update:
 *   camera.update();
 */
class Camera
{
	public var x:Float = 0;
	public var y:Float = 0;
	public var zoom(default, set):Float = 1;
	public var rotation:Float = 0;

	public var target:Entity;
	public var followSpeed:Float = 5;
	public var deadzone:Vector2D = new Vector2D(0, 0);
	public var offset:Vector2D = new Vector2D(0, 0);

	public var minX:Float = Math.NEGATIVE_INFINITY;
	public var maxX:Float = Math.POSITIVE_INFINITY;
	public var minY:Float = Math.NEGATIVE_INFINITY;
	public var maxY:Float = Math.POSITIVE_INFINITY;

	var _canvas:Sprite;
	var _shakeIntensity:Float = 0;
	var _shakeDuration:Float = 0;
	var _shakeTime:Float = 0;
	var _shakeX:Float = 0;
	var _shakeY:Float = 0;

	var _flashAlpha:Float = 0;
	var _flashColor:Int = 0xFFFFFF;
	var _flashDuration:Float = 0;
	var _flashTime:Float = 0;

	var _targetZoom:Float = 1;
	var _zoomSpeed:Float = 0;

	public function new(?canvas:Sprite)
	{
		_canvas = canvas != null ? canvas : Glue.canvas;
	}

	/**
	 * Follow an entity
	 */
	public function follow(entity:Entity, ?speed:Float = 5):Camera
	{
		target = entity;
		followSpeed = speed;
		return this;
	}

	/**
	 * Stop following
	 */
	public function unfollow():Camera
	{
		target = null;
		return this;
	}

	/**
	 * Set follow deadzone (area where camera doesn't move)
	 */
	public function setDeadzone(width:Float, height:Float):Camera
	{
		deadzone.set(width, height);
		return this;
	}

	/**
	 * Set camera bounds
	 */
	public function setBounds(minX:Float, minY:Float, maxX:Float, maxY:Float):Camera
	{
		this.minX = minX;
		this.minY = minY;
		this.maxX = maxX;
		this.maxY = maxY;
		return this;
	}

	/**
	 * Clear bounds
	 */
	public function clearBounds():Camera
	{
		minX = minY = Math.NEGATIVE_INFINITY;
		maxX = maxY = Math.POSITIVE_INFINITY;
		return this;
	}

	/**
	 * Shake the camera
	 */
	public function shake(duration:Float = 0.3, intensity:Float = 8):Camera
	{
		_shakeDuration = duration;
		_shakeIntensity = intensity;
		_shakeTime = 0;
		return this;
	}

	/**
	 * Flash the screen
	 */
	public function flash(color:Int = 0xFFFFFF, duration:Float = 0.2):Camera
	{
		_flashColor = color;
		_flashDuration = duration;
		_flashTime = 0;
		_flashAlpha = 1;
		return this;
	}

	/**
	 * Zoom to a value over time
	 */
	public function zoomTo(targetZoom:Float, speed:Float = 2):Camera
	{
		_targetZoom = targetZoom;
		_zoomSpeed = speed;
		return this;
	}

	/**
	 * Snap to position immediately
	 */
	public function snapTo(px:Float, py:Float):Camera
	{
		x = px;
		y = py;
		return this;
	}

	/**
	 * Center on a point
	 */
	public function centerOn(px:Float, py:Float):Camera
	{
		x = px - Glue.width / 2 / zoom;
		y = py - Glue.height / 2 / zoom;
		return this;
	}

	function set_zoom(value:Float):Float
	{
		zoom = Math.max(0.1, value);
		_targetZoom = zoom;
		return zoom;
	}

	/**
	 * Update camera (call each frame)
	 */
	public function update():Void
	{
		var dt = Time.deltaTime;

		// Follow target
		if (target != null)
		{
			var targetX = target.position.x + offset.x - Glue.width / 2 / zoom;
			var targetY = target.position.y + offset.y - Glue.height / 2 / zoom;

			// Apply deadzone
			var dx = targetX - x;
			var dy = targetY - y;

			if (Math.abs(dx) > deadzone.x)
			{
				x += (dx - (dx > 0 ? deadzone.x : -deadzone.x)) * followSpeed * dt;
			}

			if (Math.abs(dy) > deadzone.y)
			{
				y += (dy - (dy > 0 ? deadzone.y : -deadzone.y)) * followSpeed * dt;
			}
		}

		// Apply bounds
		x = Math.max(minX, Math.min(x, maxX - Glue.width / zoom));
		y = Math.max(minY, Math.min(y, maxY - Glue.height / zoom));

		// Update shake
		_shakeX = 0;
		_shakeY = 0;
		if (_shakeTime < _shakeDuration)
		{
			_shakeTime += dt;
			var progress = _shakeTime / _shakeDuration;
			var intensity = _shakeIntensity * (1 - progress);
			_shakeX = (Math.random() - 0.5) * 2 * intensity;
			_shakeY = (Math.random() - 0.5) * 2 * intensity;
		}

		// Update flash
		if (_flashTime < _flashDuration)
		{
			_flashTime += dt;
			_flashAlpha = 1 - (_flashTime / _flashDuration);
		}
		else
		{
			_flashAlpha = 0;
		}

		// Update zoom
		if (zoom != _targetZoom)
		{
			var diff = _targetZoom - zoom;
			if (Math.abs(diff) < 0.01)
			{
				zoom = _targetZoom;
			}
			else
			{
				zoom += diff * _zoomSpeed * dt;
			}
		}

		// Apply to canvas
		applyTransform();
	}

	function applyTransform():Void
	{
		if (_canvas == null) return;

		_canvas.scaleX = zoom;
		_canvas.scaleY = zoom;
		_canvas.x = -x * zoom + _shakeX;
		_canvas.y = -y * zoom + _shakeY;
		_canvas.rotation = rotation;

		// Draw flash overlay
		if (_flashAlpha > 0)
		{
			_canvas.graphics.clear();
			_canvas.graphics.beginFill(_flashColor, _flashAlpha);
			_canvas.graphics.drawRect(x, y, Glue.width / zoom, Glue.height / zoom);
			_canvas.graphics.endFill();
		}
		else
		{
			_canvas.graphics.clear();
		}
	}

	/**
	 * Convert screen coordinates to world coordinates
	 */
	public function screenToWorld(screenX:Float, screenY:Float):Vector2D
	{
		return new Vector2D(
			screenX / zoom + x,
			screenY / zoom + y
		);
	}

	/**
	 * Convert world coordinates to screen coordinates
	 */
	public function worldToScreen(worldX:Float, worldY:Float):Vector2D
	{
		return new Vector2D(
			(worldX - x) * zoom,
			(worldY - y) * zoom
		);
	}

	/**
	 * Check if a rectangle is visible
	 */
	public function isVisible(rx:Float, ry:Float, rw:Float, rh:Float):Bool
	{
		var viewWidth = Glue.width / zoom;
		var viewHeight = Glue.height / zoom;

		return !(rx + rw < x || rx > x + viewWidth || ry + rh < y || ry > y + viewHeight);
	}
}
