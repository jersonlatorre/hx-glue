package glue.display;

import glue.assets.Loader;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class Image extends Entity
{
	var _image:Bitmap = null;
	
	public function new(assetId:String)
	{
		super();
		_image = new Bitmap(Loader.getImage(assetId));
		_image.pixelSnapping = PixelSnapping.ALWAYS;
		_skin.addChild(_image);
		width = _skin.width;
		height = _skin.height;
		bounds.setTo(_skin.x, _skin.y, width, height);
	}

	override public function destroy() 
	{
		if (_skin != null && _image != null && _image.parent == _skin) _skin.removeChild(_image);
		super.destroy();
		_image = null;
	}
}
