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
	var _image:GImage;
	var _anim:GSprite;
	
	public function new() 
	{
		super();
		
		_image = new GImage("background_game");
		addEntity(_image);
		_anim = new GSprite("world", "Anim", 60);
		// _anim = new Gsprite.fromAnimate("world", "Anim", fps);
		// _anim = new Gsprite.fromFrames("id", width, height, fps);
		//_image.setPosition(0, 0).setAnchor(0, 0);
		addEntity(_anim);
		
		//camera.follow(_image);
		
	}
	
	override public function update():Void
	{
		//_image.position.x += 0.15 * GTime.deltaTime;
		super.update();
		_anim.update();
	}
}