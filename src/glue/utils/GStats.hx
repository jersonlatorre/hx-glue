package glue.utils;
	
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Sprite;

@:final class GStats extends Sprite
{
	private var text:TextField;
	private var background:Sprite;
	private var times:Array<Float>;
	private var memoryPeak:Float = 0;

	public function new(x:Int = 0, y:Int = 0, color:Int = 0xFFFFFF)
	{
		super();
		
		this.x = x;
		this.y = y;

		text = new TextField();
		text.width = 155;
		text.height = 63;
		text.x = 10;
		text.y = 8;
		text.selectable = false;
		text.defaultTextFormat = new TextFormat("Verdana", 11, color);

		background = new Sprite();
		background.graphics.beginFill(0x000000, 0.6);
		background.graphics.drawRect(0, 0, 155, 63);
		background.graphics.endFill();

		addChild(background);
		addChild(text);
		
		times = [];
		
		addEventListener(Event.ENTER_FRAME, onEnter);
	}
	
	private function onEnter(e:Event)
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1) times.shift();
			
		var memory:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (memory > memoryPeak) memoryPeak = memory;
		
		if (visible)
		{	
			text.htmlText = '<b><font color="#FFFF00">FPS: </font></b>${ times.length }\n<b><font color="#FFFF00">MEM: </font></b>${ memory } MB\n<b><font color="#FFFF00">MEM peak: </font></b>${ memoryPeak } MB';
		}
	}
}