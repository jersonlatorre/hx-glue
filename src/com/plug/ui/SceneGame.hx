package com.plug.ui;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import com.glue.data.GLoader;
import com.glue.display.GBitmapText;
import com.glue.display.GImage;
import com.glue.display.GTextAlignMode;
import com.glue.GEngine;
import com.glue.input.GMouse;
import com.glue.ui.GScene;
import com.glue.utils.GTime;
import com.glue.utils.GVector2D;
import com.plug.entities.Player;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author Uno
 */

class SceneGame extends GScene
{
	var _image:GImage;
	
	public function new() 
	{
		super();
		
		_image = new GImage("image");
		_image.setPosition(-500, 100);
		addEntity(_image);
		
		camera.follow(_image);
	}
	
	override public function update():Void
	{
		_image.position.x += 0.15 * GTime.deltaTime;
		super.update();
	}
}