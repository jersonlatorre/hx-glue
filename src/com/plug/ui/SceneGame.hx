package com.plug.ui;
import com.glue.display.GImage;
import com.glue.display.GMultipleSprite;
import com.glue.display.GSprite;
import com.glue.GEngine;
import com.glue.input.GMouse;
import com.glue.ui.GScene;
import com.glue.utils.GTime;
import com.glue.utils.GVector2D;
import com.plug.entities.Player;
import haxe.io.Input;
import motion.Actuate;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class SceneGame extends GScene
{
	var _background:GImage;
	var _floor:GImage;
	var _player:Player;
	
	public function new()
	{
		super();
		
		_background = new GImage("background_game");
		addEntity(_background);
		
		_floor = new GImage("floor");
		_floor.setPosition(0, GEngine.height - _floor.height);
		addEntity(_floor);
		
		_player = new Player();
		addEntity(_player);
		
		camera.follow(_player);
		camera.setBottomLimit(GEngine.height);
		camera.setLeftLimit(0);
		camera.setRightLimit(GEngine.width);
	}
	
	override public function update():Void
	{
		super.update();
	}
}