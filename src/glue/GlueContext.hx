package glue;

import openfl.display.Sprite;
import openfl.display.Stage;

final class GlueContext
{
	public final stage:Stage;
	public final canvas:Sprite;
	public var width(default, null):Int;
	public var height(default, null):Int;

	public function new(stage:Stage, canvas:Sprite, width:Int, height:Int)
	{
		this.stage = stage;
		this.canvas = canvas;
		this.width = width;
		this.height = height;
	}

	public function updateSize(width:Int, height:Int):Void
	{
		this.width = width;
		this.height = height;
	}
}
