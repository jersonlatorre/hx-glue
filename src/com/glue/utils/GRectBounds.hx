package com.glue.utils;

/**
 * ...
 * @author Uno
 */

@final class GRectBounds
{
	public var left:Float;
	public var top:Float;
	public var width:Float;
	public var height:Float;
	public var bottom:Float;
	public var right:Float;
	
	public function new(l, t, w, h) 
	{
		left = l;
		top = t;
		width = w;
		height = h;
		bottom = top - height;
		right = left + width;
	}
	
	public function toString():String
	{
		return "[\n\tleft: " + left + "\n\ttop: " + top + "\n\twidth: " + width + "\n\theight: " + height + "\n\tbottom: " + bottom + "\n\tright: " + right + "\n]";
	}
	
}