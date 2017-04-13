package glue.display;

import glue.data.GLoader;
import openfl.display.Bitmap;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GImage extends GEntity
{
	var _image:Bitmap;
	
	public function new(id:String)
	{
		super();
		
		_image = GLoader.getImage(id);
		_skin.addChild(_image);
		
		width = _skin.width;
		height = _skin.height;
	}

	override public function destroy() 
	{
		super.destroy();
	}
}