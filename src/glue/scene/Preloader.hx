package glue.scene;

import glue.assets.Loader;
import glue.scene.Popup;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

class Preloader extends Popup
{
	private var _bar:Sprite;
	
	override public function init()
	{
		_bar = new Sprite();
		canvas.addChild(_bar);
	}
	
	override public function update()
	{
		var width:Float = context.width;
		var height:Float = context.height;

		_bar.graphics.clear();
		_bar.graphics.beginFill(0x55AA77, 1);
		
		if (Loader.totalFiles != 0)
		{
			_bar.graphics.drawRect(0, height * 0.5 - 3, width * Loader.downloadedFiles / Loader.totalFiles, 2);
		}

		_bar.graphics.endFill();
	}
}
