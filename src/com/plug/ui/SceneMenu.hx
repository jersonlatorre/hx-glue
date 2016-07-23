package com.plug.ui;
import com.glue.data.GDataManager;
import com.glue.data.GImageManager;
import com.glue.data.GSoundManager;
import com.glue.entities.GAlignMode;
import com.glue.entities.GImage;
import com.glue.entities.GSpriteButton;
import com.glue.GEngine;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GScene;
import com.glue.ui.GSceneManager;
import openfl.Assets;
import openfl.display.BitmapData;
import com.plug.Global;

/**
 * ...
 * @author Uno
 */

class SceneMenu extends GScene
{
	private var _background:GImage;
	private var _button:GSpriteButton;
	
	public function new() 
	{
		super();
		
		var data:Dynamic = GDataManager.getJson("config");
		
		Global.playButtonPosition.x = data.play_button_position[0];
		Global.playButtonPosition.y = data.play_button_position[1];
		Global.replayButtonPosition.x = data.replay_button_position[0];
		Global.replayButtonPosition.y = data.replay_button_position[1];
		Global.scoreGamePosition.x = data.score_game_position[0];
		Global.scoreGamePosition.y = data.score_game_position[1];
		Global.scoreFinalPosition.x = data.score_final_position[0];
		Global.scoreFinalPosition.y = data.score_final_position[1];
		
		_background = new GImage("background_menu", GAlignMode.CENTER);
		addEntity(_background);
		
		_button = new GSpriteButton("button_play", GAlignMode.CENTER, function():Void
		{
			GSceneManager.gotoScreen(SceneGame);
			GSoundManager.stop("bgm_menu");
		});
		
		addEntity(_button);
		
		_button.position.x = Global.playButtonPosition.x;
		_button.position.y = Global.playButtonPosition.y;
		
		_button.addOverSound("button_over");
		_button.addDownSound("button_down");
		
		GSoundManager.loop("bgm_menu");
	}
	
	override public function update():Void
	{
		//if (GKeyboard.isSpace)
		//{
			//GScreenManager.gotoScreen(ScreenGame);
		//}
		
		super.update();
	}
}