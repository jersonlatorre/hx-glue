package com.glue.utils;
	
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 */
class GStats extends TextField
{
	private var times:Array<Float>;
	private var memPeak:Float = 0;

	public function new(inX:Float = 0.0, inY:Float = 0.0, inCol:Int = 0x000000) 
	{
		super();
		
		x = inX;
		y = inY;
		selectable = false;
		
		defaultTextFormat = new TextFormat("Arial", 12, inCol);
		
		text = "FPS: ";
		
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;
	}
	
	private function onEnter(_)
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1)
			times.shift();
			
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;
		
		if (visible)
		{	
			text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";	
		}
	}
	
}

//import haxe.Timer;
//import openfl.display.FPS;
//import openfl.display.Sprite;
//import openfl.events.Event;
//import openfl.system.System;
//import openfl.text.TextField;
//import openfl.text.TextFormat;
//
///**
 //* FPS class extension to display memory usage.
 //* @author Kirill Poletaev
 //*/
//
//@final class GStats extends Sprite
//{
	//var times:Array<Float>;
	//var textfield:TextField;
//
	//public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000) 
	//{
		//super();
		//
		//textfield = new TextField();
		//
		//this.x = x;
		//this.y = y;
		//textfield.selectable = false;
		//
		//var format = new TextFormat("Arial", 12, color);
		//textfield.defaultTextFormat = format;
		//textfield.setTextFormat(format);
		//
		//addChild(textfield);
		//textfield.text = "FPS: ";
		//times = [];
		//addEventListener(Event.ENTER_FRAME, onEnter);
		//textfield.width = 70;
		//textfield.height = 70;
	//}
	//
	//function onEnter(e:Event)
	//{	
		//var now = Timer.stamp();
		//times.push(now);
		//
		//while (times[0] < now - 1)
		//{
			//times.shift();
		//}
			//
		//if (visible)
		//{	
			//textfield.text = "FPS: " + times.length;	
		//}
	//}
//}