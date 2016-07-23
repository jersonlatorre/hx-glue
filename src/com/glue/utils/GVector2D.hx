package com.glue.utils;

import flash.geom.Vector3D;
/**
 * ...
 * @author Uno
 */

@final class GVector2D 
{
	public var x:Float;
	public var y:Float;
	
	public function new(x:Float, y:Float) 
	{
		this.x = x;
		this.y = y;
	}
	
	static public function add(v1:GVector2D, v2:GVector2D):GVector2D
	{
		return new GVector2D(v1.x + v2.x, v1.y + v2.y);
	}
	
	static public function sub(v1:GVector2D, v2:GVector2D):GVector2D
	{
		return new GVector2D(v1.x - v2.x, v1.y - v2.y);
	}
	
	static public function scale(v:GVector2D, k:Float):GVector2D
	{
		return new GVector2D(k * v.x , k * v.y);
	}
	
	static public function magnitude(v:GVector2D):Float
	{
		return Math.sqrt(v.x * v.x + v.y * v.y);
	}
	
	static public function normalize(v:GVector2D):GVector2D
	{
		return GVector2D.scale(v, 1 / GVector2D.magnitude(v));
	}
	
	static public function rotate(v:GVector2D, angle:Float):GVector2D
	{
		var rx:Float = v.x * Math.cos(angle) - v.y * Math.sin(angle);
		var ry:Float = v.x * Math.sin(angle) + v.y * Math.cos(angle);
		
		return new GVector2D(rx, ry);
	}
	
	static public function pointProduct(a:GVector2D, b:GVector2D):Float
	{
		return (a.x * b.x + a.y + b.y);
	}
	
	static public function create(x:Float, y:Float):GVector2D
	{
		return new GVector2D(x, y);
	}
	
	public function toString():String
	{
		return "[" + Std.int(x) + ", " + Std.int(y) + "]";
	}
}