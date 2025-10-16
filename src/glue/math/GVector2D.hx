package glue.math;

/**
 * Modern 2D vector with operator overloading and implicit conversions
 * Supports fluent API and reduced verbosity
 */
@:forward
abstract GVector2D(__GVectorBase) from __GVectorBase to __GVectorBase
{
  public inline function new(x:Float = 0, y:Float = 0)
  {
    this = new __GVectorBase(x, y);
  }

  // Static factory for clarity
  static public inline function create(x:Float = 0, y:Float = 0)
  {
    return new GVector2D(x, y);
  }

  // Implicit conversion from array [x, y]
  @:from static public inline function fromArray(arr:Array<Float>):GVector2D
  {
    return new GVector2D(arr[0], arr[1]);
  }

  // Implicit conversion from anonymous structure
  @:from static public inline function fromStruct(obj:{x:Float, y:Float}):GVector2D
  {
    return new GVector2D(obj.x, obj.y);
  }

  // Shorthand for common vectors
  static public var zero(get, never):GVector2D;
  static public var one(get, never):GVector2D;
  static public var up(get, never):GVector2D;
  static public var down(get, never):GVector2D;
  static public var left(get, never):GVector2D;
  static public var right(get, never):GVector2D;

  static inline function get_zero():GVector2D return new GVector2D(0, 0);
  static inline function get_one():GVector2D return new GVector2D(1, 1);
  static inline function get_up():GVector2D return new GVector2D(0, -1);
  static inline function get_down():GVector2D return new GVector2D(0, 1);
  static inline function get_left():GVector2D return new GVector2D(-1, 0);
  static inline function get_right():GVector2D return new GVector2D(1, 0);

  static public function lerp(v1:GVector2D, v2:GVector2D, t:Float):GVector2D
  {
    return v1 + (v2 - v1) * t;
  }

  static public function distance(v1:GVector2D, v2:GVector2D)
  {
    return (v1 - v2).magnitude();
  }

  static public function distanceSq(v1:GVector2D, v2:GVector2D)
  {
    return (v1 - v2).magnitudeSq();
  }

  @:op(A + B) static public function add(v1:GVector2D, v2:GVector2D):GVector2D
  {
    return new GVector2D(v1.x + v2.x, v1.y + v2.y);
  }

  @:op(A - B) static public function sub(v1:GVector2D, v2:GVector2D):GVector2D
  {
    return new GVector2D(v1.x - v2.x, v1.y - v2.y);
  }

  @:op(A * B) static public function scaleleft(k:Float, v:GVector2D):GVector2D
  {
    return new GVector2D(k * v.x, k * v.y);
  }

  @:op(A * B) static public function scaleright(v:GVector2D, k:Float):GVector2D
  {
    return new GVector2D(k * v.x, k * v.y);
  }

  @:op(A / B) static public function div(v:GVector2D, k:Float):GVector2D
  {
    return new GVector2D(v.x / k, v.y / k);
  }
}

@:final class __GVectorBase
{
  public var x:Float;
  public var y:Float;

  public function new(x:Float = 0, y:Float = 0)
  {
    this.x = x;
    this.y = y;
  }

  public function set(x:Float, y:Float):GVector2D
  {
    this.x = x;
    this.y = y;
    return this;
  }

  public function clone():GVector2D
  {
    return GVector2D.create(x, y);
  }

  public function scale(factor:Float):GVector2D
  {
    x *= factor;
    y *= factor;
    return this;
  }

  public function angle():Float
  {
    return Math.atan2(y, x);
  }

  public function magnitude():Float
  {
    return Math.sqrt(x * x + y * y);
  }

  public function magnitudeSq():Float
  {
    return (x * x + y * y);
  }

  public function normalize():GVector2D
  {
    var factor:Float = 0;

    if (magnitudeSq() != 0)
    {
      factor = 1 / magnitude();
    }
    
    x *= factor;
    y *= factor;

    return this;
  }

  public function normalized():GVector2D
  {
    var normalized = new GVector2D();

    if (magnitudeSq() != 0)
    {
      var factor = 1 / magnitude();
      normalized = new GVector2D(x * factor, y * factor);
    }
    
    return normalized;
  }

  public function truncate(maxMagnitude:Float):GVector2D
  {
    if (magnitudeSq() > maxMagnitude * maxMagnitude)
    {
      normalize();
      scale(maxMagnitude);
    }

    return this;
  }

  public function truncated(maxMagnitude:Float):GVector2D
  {
    if (magnitudeSq() > maxMagnitude * maxMagnitude)
    {
      return normalized() * maxMagnitude;
    }

    else return clone();
  }

  public function scaleTo(magnitude:Float):GVector2D
  {
    normalize();
    scale(magnitude);
    return this;
  }

  public function scaledTo(magnitude:Float):GVector2D
  {
    return normalized() * magnitude;
  }
  
  public function rotate(angle:Float):GVector2D
  {
    var rx:Float = x * Math.cos(angle) - y * Math.sin(angle);
    var ry:Float = x * Math.sin(angle) + y * Math.cos(angle);

    return new GVector2D(rx, ry);
  }

  public function dot(a:GVector2D):Float
  {
    return (a.x * x + a.y * y);
  }

  public function cross(a:GVector2D):Float
  {
    return (x * a.y - y * a.x);
  }

  public function toString():String
  {
    return "[" + x + ", " + y + "]";
  }
}
