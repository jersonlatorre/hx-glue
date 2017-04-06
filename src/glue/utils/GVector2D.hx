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

  @:op(A + B) static public function add(a:GVector2D, b:GVector2D):GVector2D
  {
    return new GVector2D(a.x + b.x, a.y + b.y);
  }

  @:op(A - B) static public function sub(a:GVector2D, b:GVector2D):GVector2D
  {
    return new GVector2D(a.x - b.x, a.y - b.y);
  }

  @:op(A * B) static public function scaleleft(k:Float, a:GVector2D):GVector2D
  {
    return new GVector2D(k * a.x, k * a.y);
  }

  @:op(A * B) static public function scaleright(a:GVector2D, k:Float):GVector2D
  {
    return new GVector2D(k * a.x, k * a.y);
  }

  @:op(A / B) static public function div(a:GVector2D, k:Float):GVector2D
  {
    return new GVector2D(a.x / k, a.y / k);
  }
}

@final class __GVectorBasehttps://www.codeproject.com/Articles/3386/A-Java-Style-Vector-Class-in-C
{
  public var x:Float;
  public var y:Float;

  public function new(x:Float = 0, y:Float = 0)
  {
    this.x = x;
    this.y = y;
  }

  public function magnitude():Float
  {
    return Math.sqrt(x * x + y * y);
  }

  public function normalize():Void
  {
    var factor = 1 / magnitude();
    x *= factor;
    y *= factor;
  }

  public function normalized():GVector2D
  {
    var factor = 1 / magnitude();
    return (new GVector2D(x * factor, y * factor));
  }

  public function rotate(angle:Float):GVector2D
  {
    var rx:Float = x * GMath.cos(angle) - y * GMath.sin(angle);
    var ry:Float = x * GMath.sin(angle) + y * GMath.cos(angle);
		
    return new GVector2D(rx, ry);
  }

  public function distance(v1:GVector2D, v2:GVector2D):GVector2D
  {
    return (v1 - v2).magnitude;
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