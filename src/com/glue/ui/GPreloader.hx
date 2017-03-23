package com.glue.ui;

import com.glue.ui.GScene;
import com.glue.data.GLoader;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */
class GPreloader extends GScene
{
	private var _bar:Sprite;
	
	public function new() 
	{
		super();
		_bar = new Sprite();
		_canvas.addChild(_bar);
	}
	
	override public function update():Void 
	{
		var width:Float = Glue.width;
		var height:Float = Glue.height;

		_bar.graphics.beginFill(0x110000);
		_bar.graphics.drawRect(0, 0, width , height);
		_bar.graphics.endFill();
		_bar.graphics.beginFill(0xFF0000);
		_bar.graphics.drawRect(0, height / 2 - 3, width * GLoader.downloadedFiles / GLoader.totalFiles, 6);
		_bar.graphics.endFill();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
}