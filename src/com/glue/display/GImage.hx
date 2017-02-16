package com.glue.display;
import com.glue.data.GLoader;
import flash.display.Bitmap;

/**
 * ...
 * @author uno
 * 
 */

class GImage extends GEntity
{
	var _image:Bitmap;
	
	public function new(id:String):Void
	{
		super();
		
		_image = GLoader.getImage(id);
		_skin.addChild(_image);
		
		_width = _skin.width;
		_height = _skin.height;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
}