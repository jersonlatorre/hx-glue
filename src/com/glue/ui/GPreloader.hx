package com.glue.ui;

import com.glue.ui.GScene;
import com.glue.data.GLoader;
import openfl.Lib;
import openfl.display.Sprite;

/**
 * ...
 * @author Uno
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
		var width:Float = Lib.application.window.width;
		var height:Float = Lib.application.window.height;
		
		_bar.graphics.beginFill(0x111111);
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