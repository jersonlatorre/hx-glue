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
 *
 */

class SceneGame extends GScene
{
	var _image:GImage;
	var _anims:Array<GSprite> = new Array<GSprite>();
	var _elapsed:Int = 0;
	
	public function new()
	{
		super();
		
		_image = new GImage("background_game");
		addEntity(_image);
		
		addAnim();

		//_image.setPosition(0, 0).setAnchor(0, 0);
		
		//camera.follow(_image);
	}

	function addAnim()
	{
		var anim = new GSprite("circle_idle", 30);
		anim.position.x = Math.random() * 500;
		anim.position.y = Math.random() * 500;
		_anims.push(anim);
		addEntity(anim);
	}
	
	override public function update():Void
	{
		super.update();

		for (i in 0..._anims.length)
		{
			_anims[i].update();
		}
	}
}