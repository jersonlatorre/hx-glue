package glue.display;

import glue.assets.GLoader;
import openfl.display.Bitmap;
import openfl.display.Shape;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GImage extends GEntity
{
	var _image:Bitmap = null;
	
	public function new()
	{
		super();
	}

	public function createFromAsset(assetId:String)
	{
		_image = GLoader.getImage(assetId);
		_skin.addChild(_image);
		this.width = _skin.width;
		this.height = _skin.height;
	}

	override public function createRectangleShape(width:Float, height:Float, color:UInt = 0x000000)
	{
		this.width = width;
		this.height = height;

		var graphic = new Shape();
		graphic.graphics.beginFill(color);
		graphic.graphics.drawRect(0, 0, width, height);
		graphic.graphics.endFill();

		_skin.addChild(graphic);
	}

	override public function createCircleShape(radius:Float, color:UInt = 0x000000)
	{
		this.width = this.height = 2 * radius;

		var graphic = new Shape();
		graphic.graphics.beginFill(color);
		graphic.graphics.drawCircle(radius, radius, radius);
		graphic.graphics.endFill();

		_skin.addChild(graphic);
	}

	override public function destroy() 
	{
		_skin.removeChild(_image);
		super.destroy();
		_image.bitmapData.dispose;
		_image = null;
	}
}