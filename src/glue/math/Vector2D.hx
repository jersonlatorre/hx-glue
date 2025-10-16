package glue.math;

/**
 * Modern 2D vector with operator overloading and implicit conversions
 * Supports fluent API and reduced verbosity
 */
@:forward
abstract Vector2D(__GVectorBase) from __GVectorBase to __GVectorBase
{
  public inline function new(x:Float = 0, y:Float = 0)
  {
    this = new __GVectorBase(x, y);
  }

  static public inline function create(x:Float = 0, y:Float = 0)
  {
    return new Vector2D(x, y);
  }

  @:from static public inline function fromArray(arr:Array<Float>):Vector2D
  {
    return new Vector2D(arr[0], arr[1]);
  }

  @:from static public inline function fromStruct(obj:{x:Float, y:Float}):Vector2D
  {
    return new Vector2D(obj.x, obj.y);
  }

  static public var zero(get, never):Vector2D;
  static public var one(get, never):Vector2D;
  static public var up(get, never):Vector2D;
  static public var down(get, never):Vector2D;
  static public var left(get, never):Vector2D;
  static public var right(get, never):Vector2D;

  static inline function get_zero():Vector2D return new Vector2D(0, 0);
  static inline function get_one():Vector2D return new Vector2D(1, 1);
  static inline function get_up():Vector2D return new Vector2D(0, -1);
  static inline function get_down():Vector2D return new Vector2D(0, 1);
  static inline function get_left():Vector2D return new Vector2D(-1, 0);
  static inline function get_right():Vector2D return new Vector2D(1, 0);

  static public function lerp(v1:Vector2D, v2:Vector2D, t:Float):Vector2D
  {
    return v1 + (v2 - v1) * t;
  }

  static public function distance(v1:Vector2D, v2:Vector2D)
  {
    return (v1 - v2).magnitude();
  }

  static public function distanceSq(v1:Vector2D, v2:Vector2D)
  {
    return (v1 - v2).magnitudeSq();
  }

  @:op(A + B) static public function add(v1:Vector2D, v2:Vector2D):Vector2D
  {
    return new Vector2D(v1.x + v2.x, v1.y + v2.y);
  }

  @:op(A - B) static public function sub(v1:Vector2D, v2:Vector2D):Vector2D
  {
    return new Vector2D(v1.x - v2.x, v1.y - v2.y);
  }

  @:op(A * B) static public function scaleleft(k:Float, v:Vector2D):Vector2D
  {
    return new Vector2D(k * v.x, k * v.y);
  }

  @:op(A * B) static public function scaleright(v:Vector2D, k:Float):Vector2D
  {
    return new Vector2D(k * v.x, k * v.y);
  }

  @:op(A / B) static public function div(v:Vector2D, k:Float):Vector2D
  {
    return new Vector2D(v.x / k, v.y / k);
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

  public function set(x:Float, y:Float):Vector2D
  {
    this.x = x;
    this.y = y;
    return this;
  }

  public function clone():Vector2D
  {
    return Vector2D.create(x, y);
  }

  public function scale(factor:Float):Vector2D
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

  public function normalize():Vector2D
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

  public function normalized():Vector2D
  {
    var normalized = new Vector2D();

    if (magnitudeSq() != 0)
    {
      var factor = 1 / magnitude();
      normalized = new Vector2D(x * factor, y * factor);
    }
    
    return normalized;
  }

  public function truncate(maxMagnitude:Float):Vector2D
  {
    if (magnitudeSq() > maxMagnitude * maxMagnitude)
    {
      normalize();
      scale(maxMagnitude);
    }

    return this;
  }

  public function truncated(maxMagnitude:Float):Vector2D
  {
    if (magnitudeSq() > maxMagnitude * maxMagnitude)
    {
      return normalized() * maxMagnitude;
    }

    else return clone();
  }

  public function scaleTo(magnitude:Float):Vector2D
  {
    normalize();
    scale(magnitude);
    return this;
  }

  public function scaledTo(magnitude:Float):Vector2D
  {
    return normalized() * magnitude;
  }
  
  public function rotate(angle:Float):Vector2D
  {
    var rx:Float = x * Math.cos(angle) - y * Math.sin(angle);
    var ry:Float = x * Math.sin(angle) + y * Math.cos(angle);

    return new Vector2D(rx, ry);
  }

  public function dot(a:Vector2D):Float
  {
    return (a.x * x + a.y * y);
  }

  public function cross(a:Vector2D):Float
  {
    return (x * a.y - y * a.x);
  }

  public function toString():String
  {
    return "[" + x + ", " + y + "]";
  }
}
