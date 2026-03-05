package glue.effects;

import glue.display.Entity;
import glue.math.Vector2D;
import glue.style.Palette;
import glue.utils.Time;
import openfl.display.Graphics;

/**
 * Simple particle system with beautiful defaults.
 *
 * Usage:
 *   var emitter = new Particles()
 *       .colors([Palette.CORAL, Palette.GOLD, Palette.CRIMSON])
 *       .burst(20);
 *
 *   // Presets
 *   Particles.explosion(x, y);
 *   Particles.sparkle(x, y);
 *   Particles.smoke(x, y);
 */
class Particles extends Entity
{
	var _particles:Array<Particle> = [];
	var _emitting:Bool = false;
	var _emitTimer:Float = 0;
	var _emitRate:Float = 10;

	// Configuration
	var _colors:Array<Int> = [Palette.WHITE];
	var _minLife:Float = 0.5;
	var _maxLife:Float = 1.5;
	var _minSpeed:Float = 50;
	var _maxSpeed:Float = 150;
	var _minSize:Float = 2;
	var _maxSize:Float = 6;
	var _minAngle:Float = 0;
	var _maxAngle:Float = Math.PI * 2;
	var _gravity:Float = 0;
	var _friction:Float = 0;
	var _fadeOut:Bool = true;
	var _shrink:Bool = true;
	var _spread:Float = 0;
	var _shape:ParticleShape = Circle;

	public function new()
	{
		super();
	}

	// Chainable configuration

	/**
	 * Set particle colors (randomly selected)
	 */
	public function colors(c:Array<Int>):Particles
	{
		_colors = c;
		return this;
	}

	/**
	 * Set single color
	 */
	public function color(c:Int):Particles
	{
		_colors = [c];
		return this;
	}

	/**
	 * Set lifetime range
	 */
	public function life(min:Float, max:Float):Particles
	{
		_minLife = min;
		_maxLife = max;
		return this;
	}

	/**
	 * Set speed range
	 */
	public function speed(min:Float, max:Float):Particles
	{
		_minSpeed = min;
		_maxSpeed = max;
		return this;
	}

	/**
	 * Set size range
	 */
	public function size(min:Float, max:Float):Particles
	{
		_minSize = min;
		_maxSize = max;
		return this;
	}

	/**
	 * Set emission angle range (radians)
	 */
	public function angle(min:Float, max:Float):Particles
	{
		_minAngle = min;
		_maxAngle = max;
		return this;
	}

	/**
	 * Emit upward
	 */
	public function upward():Particles
	{
		_minAngle = -Math.PI * 0.75;
		_maxAngle = -Math.PI * 0.25;
		return this;
	}

	/**
	 * Emit downward
	 */
	public function downward():Particles
	{
		_minAngle = Math.PI * 0.25;
		_maxAngle = Math.PI * 0.75;
		return this;
	}

	/**
	 * Set gravity
	 */
	public function withGravity(g:Float = 400):Particles
	{
		_gravity = g;
		return this;
	}

	/**
	 * Set friction (0-1)
	 */
	public function withFriction(f:Float = 0.98):Particles
	{
		_friction = f;
		return this;
	}

	/**
	 * Set spawn spread radius
	 */
	public function spread(radius:Float):Particles
	{
		_spread = radius;
		return this;
	}

	/**
	 * Set particle shape
	 */
	public function shape(s:ParticleShape):Particles
	{
		_shape = s;
		return this;
	}

	/**
	 * Disable fade out
	 */
	public function noFade():Particles
	{
		_fadeOut = false;
		return this;
	}

	/**
	 * Disable shrinking
	 */
	public function noShrink():Particles
	{
		_shrink = false;
		return this;
	}

	// Emission methods

	/**
	 * Emit a burst of particles
	 */
	public function burst(count:Int):Particles
	{
		for (i in 0...count)
		{
			emit();
		}
		return this;
	}

	/**
	 * Start continuous emission
	 */
	public function start(rate:Float = 10):Particles
	{
		_emitRate = rate;
		_emitting = true;
		return this;
	}

	/**
	 * Stop continuous emission
	 */
	public function stop():Particles
	{
		_emitting = false;
		return this;
	}

	/**
	 * Emit a single particle
	 */
	public function emit():Void
	{
		var p = new Particle();

		// Position with spread
		if (_spread > 0)
		{
			var angle = Math.random() * Math.PI * 2;
			var dist = Math.random() * _spread;
			p.x = Math.cos(angle) * dist;
			p.y = Math.sin(angle) * dist;
		}

		// Velocity
		var angle = _minAngle + Math.random() * (_maxAngle - _minAngle);
		var speed = _minSpeed + Math.random() * (_maxSpeed - _minSpeed);
		p.vx = Math.cos(angle) * speed;
		p.vy = Math.sin(angle) * speed;

		// Properties
		p.life = _minLife + Math.random() * (_maxLife - _minLife);
		p.maxLife = p.life;
		p.size = _minSize + Math.random() * (_maxSize - _minSize);
		p.startSize = p.size;
		p.color = _colors[Std.int(Math.random() * _colors.length)];

		_particles.push(p);
	}

	override public function update():Void
	{
		var dt = Time.deltaTime;

		// Continuous emission
		if (_emitting)
		{
			_emitTimer += dt;
			var interval = 1.0 / _emitRate;
			while (_emitTimer >= interval)
			{
				emit();
				_emitTimer -= interval;
			}
		}

		// Update particles
		var g = _skin.graphics;
		g.clear();

		var i = _particles.length - 1;
		while (i >= 0)
		{
			var p = _particles[i];

			// Physics
			p.vy += _gravity * dt;
			if (_friction > 0)
			{
				p.vx *= (1 - _friction * dt);
				p.vy *= (1 - _friction * dt);
			}
			p.x += p.vx * dt;
			p.y += p.vy * dt;
			p.life -= dt;

			// Fade/shrink
			var progress = 1 - (p.life / p.maxLife);
			var alpha = _fadeOut ? (1 - progress) : 1;
			var size = _shrink ? p.startSize * (1 - progress) : p.size;

			if (p.life <= 0)
			{
				_particles.splice(i, 1);
			}
			else
			{
				// Draw
				g.beginFill(p.color, alpha);
				switch (_shape)
				{
					case Circle:
						g.drawCircle(p.x, p.y, size);
					case Square:
						g.drawRect(p.x - size, p.y - size, size * 2, size * 2);
					case Diamond:
						drawDiamond(g, p.x, p.y, size);
				}
				g.endFill();
			}

			i--;
		}
	}

	function drawDiamond(g:Graphics, x:Float, y:Float, size:Float):Void
	{
		g.moveTo(x, y - size);
		g.lineTo(x + size, y);
		g.lineTo(x, y + size);
		g.lineTo(x - size, y);
		g.lineTo(x, y - size);
	}

	/**
	 * Number of active particles
	 */
	public var count(get, never):Int;

	function get_count():Int
	{
		return _particles.length;
	}

	/**
	 * Check if any particles are alive
	 */
	public var isAlive(get, never):Bool;

	function get_isAlive():Bool
	{
		return _particles.length > 0 || _emitting;
	}

	// Presets

	/**
	 * Explosion effect
	 */
	public static function explosion(x:Float, y:Float, ?color:Int):Particles
	{
		var p = new Particles();
		p.position.set(x, y);
		p.colors(color != null ? [color, Palette.lighter(color)] : [Palette.CORAL, Palette.GOLD, Palette.WHITE]);
		p.speed(100, 300);
		p.size(3, 8);
		p.life(0.3, 0.8);
		p.withGravity(200);
		p.burst(30);
		return p;
	}

	/**
	 * Sparkle effect
	 */
	public static function sparkle(x:Float, y:Float):Particles
	{
		var p = new Particles();
		p.position.set(x, y);
		p.colors([Palette.WHITE, Palette.CYAN, Palette.SKY]);
		p.speed(20, 80);
		p.size(1, 4);
		p.life(0.5, 1.2);
		p.shape(Diamond);
		p.burst(15);
		return p;
	}

	/**
	 * Smoke effect
	 */
	public static function smoke(x:Float, y:Float):Particles
	{
		var p = new Particles();
		p.position.set(x, y);
		p.colors([Palette.STORM, Palette.STEEL, Palette.MIDNIGHT]);
		p.speed(30, 60);
		p.size(8, 16);
		p.life(1, 2);
		p.upward();
		p.withFriction(2);
		p.noShrink();
		p.spread(10);
		p.start(8);
		return p;
	}

	/**
	 * Fire effect
	 */
	public static function fire(x:Float, y:Float):Particles
	{
		var p = new Particles();
		p.position.set(x, y);
		p.colors([Palette.CRIMSON, Palette.CORAL, Palette.GOLD]);
		p.speed(40, 100);
		p.size(4, 10);
		p.life(0.4, 0.8);
		p.upward();
		p.spread(8);
		p.start(20);
		return p;
	}

	/**
	 * Trail effect (attach to moving entity)
	 */
	public static function trail(?color:Int):Particles
	{
		var p = new Particles();
		p.colors(color != null ? [color] : [Palette.SKY, Palette.CYAN]);
		p.speed(5, 20);
		p.size(2, 5);
		p.life(0.2, 0.5);
		p.start(30);
		return p;
	}

	/**
	 * Confetti effect
	 */
	public static function confetti(x:Float, y:Float):Particles
	{
		var p = new Particles();
		p.position.set(x, y);
		p.colors([Palette.CRIMSON, Palette.CORAL, Palette.GOLD, Palette.LIME, Palette.SKY, Palette.PURPLE]);
		p.speed(100, 250);
		p.size(3, 6);
		p.life(1, 2);
		p.angle(-Math.PI * 0.8, -Math.PI * 0.2);
		p.withGravity(300);
		p.shape(Square);
		p.noShrink();
		p.burst(50);
		return p;
	}
}

private class Particle
{
	public var x:Float = 0;
	public var y:Float = 0;
	public var vx:Float = 0;
	public var vy:Float = 0;
	public var life:Float = 1;
	public var maxLife:Float = 1;
	public var size:Float = 4;
	public var startSize:Float = 4;
	public var color:Int = 0xFFFFFF;
}

enum ParticleShape
{
	Circle;
	Square;
	Diamond;
}
