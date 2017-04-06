package glue.utils;

@:forward 
abstract GVector2D(__GVectorBase) from __GVectorBase to __GVectorBase
{
  public function new(x:Float, y:Float)
  {
    return new __GVectorBase(x, y);
  }

  static public function create(x:Float, y:Float)
  {
    return new GVector2D(x, y);
  }

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

@final class __GVectorBasehttps
{
  public var x:Float;
  public var y:Float;

  public function new(x:Float = 0, y:Float = 0)
  {
    this.x = x;
    this.y = y;
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
    var factor = 1 / magnitude();
    x *= factor;
    y *= factor;
    return this;
  }

  public function normalized():GVector2D
  {
    var factor = 1 / magnitude();
    return (new GVector2D(x * factor, y * factor));
  }

  public function truncate(maxMagnitude:Float):GVector2D
  {
    if (magnitude() > maxMagnitude) normalize().scale(maxMagnitude);
    return this;
  }

  public function truncated(maxMagnitude:Float):GVector2D
  {
    if (magnitude() > maxMagnitude) return normalized().scale(maxMagnitude)
    else return clone();
  }
  
  public function rotate(angle:Float):GVector2D
  {
    var rx:Float = x * GMath.cos(angle) - y * GMath.sin(angle);
    var ry:Float = x * GMath.sin(angle) + y * GMath.cos(angle);
		
    return new GVector2D(rx, ry);
  }

  public function dot(a:GVector2D):Float
  {
    return (a.x * x + a.y + y);
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