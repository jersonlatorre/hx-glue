package com.plug.ui;
import com.glue.data.GLoader;
import com.glue.display.GImage;
import com.glue.display.GSprite;
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
	var _image:GSprite;
	
	public function new() 
	{
		super();
		
		//_image = new GSprite("world", "Anim", 30);
		//_image.setPosition(0, 0).setAnchor(0, 0);
		//addEntity(_image);
		
		_image = new GSprite(
		
		//camera.follow(_image);
		
	}
	
	override public function update():Void
	{
		//_image.position.x += 0.15 * GTime.deltaTime;
		super.update();
	}
}