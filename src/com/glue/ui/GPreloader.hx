package com.glue.ui;

import com.glue.ui.GScene;
import com.glue.data.GLoaderManager;
import openfl.Lib;

/**
 * ...
 * @author Uno
 */
class GPreloader extends GScene
{
	public function new() 
	{
		super();
	}
	
	override public function update():Void 
	{
		var width:Float = Lib.application.window.width;
		var height:Float = Lib.application.window.height;
		
		canvas.graphics.beginFill(0x111111);
		canvas.graphics.drawRect(0, 0, width , height);
		canvas.graphics.endFill();
		
		canvas.graphics.beginFill(0xFF0000);
		canvas.graphics.drawRect(0, height / 2 - 3, width * GLoaderManager.downladedFiles / GLoaderManager.totalFiles, 6);
		canvas.graphics.endFill();
	}
}