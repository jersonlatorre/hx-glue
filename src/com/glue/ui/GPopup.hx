package com.glue.ui;

import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

class GPopup 
{	
	public var canvas:Sprite;
	
	public function new() 
	{
		canvas = new Sprite();
		GSceneManager.popupCanvas.addChild(canvas);
	}
	
	public function update():Void
	{
	}
	
	public function destroy():Void
	{
		while (GSceneManager.popupCanvas.numChildren > 0)
		{
			GSceneManager.popupCanvas.removeChildAt(0);
		}
		
		canvas = null;
	}
}