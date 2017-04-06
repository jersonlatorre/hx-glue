package glue.ui;

import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

class GPopup 
{	
	var _canvas:Sprite;
	
	public function new() 
	{
		_canvas = new Sprite();
		GSceneManager.canvas.addChild(_canvas);
	}
	
	public function update():Void
	{
	}
	
	public function destroy():Void
	{
		while (_canvas.numChildren > 0)
		{
			_canvas.removeChildAt(0);
		}

		GSceneManager.canvas.removeChild(_canvas);
		
		_canvas = null;
	}
}