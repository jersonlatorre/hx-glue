package com.glue.entities;
import com.glue.data.GImageManager;
import flash.display.Bitmap;

/**
 * ...
 * @author uno
 * 
 */

class GImage extends GEntity
{
	var _image:Bitmap;
	
	public function new(id:String, alignType:Int = 0):Void
	{
		super(alignType);
		
		_image = GImageManager.getImage(id);
		_content.addChild(_image);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		//_image.bitmapData.dispose();
		_image = null;
	}
}