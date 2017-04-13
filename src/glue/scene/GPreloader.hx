package glue.scene;

import glue.assets.GLoader;
import glue.scene.GPopup;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

class GPreloader extends GPopup
{
	private var _bar:Sprite;
	
	override public function init()
	{
		_bar = new Sprite();
		_canvas.addChild(_bar);
	}
	
	override public function update()
	{
		var width:Float = Glue.width;
		var height:Float = Glue.height;

		_bar.graphics.beginFill(0xFF0000);
		
		if (GLoader.totalFiles != 0)
		{
			_bar.graphics.drawRect(0, height / 2 - 3, width * GLoader.downloadedFiles / GLoader.totalFiles, 6);
		}

		_bar.graphics.endFill();
	}
}