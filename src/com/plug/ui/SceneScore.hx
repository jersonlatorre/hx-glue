package com.plug.ui;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import com.glue.data.GDataManager;
import com.glue.data.GImageManager;
import com.glue.data.GSoundManager;
import com.glue.entities.GAlignMode;
import com.glue.entities.GBitmapText;
import com.glue.entities.GImage;
import com.glue.entities.GSpriteButton;
import com.glue.entities.GTextAlignMode;
import com.glue.input.GKeyboard;
import com.glue.input.GMouse;
import com.glue.ui.GScene;
import com.glue.ui.GSceneManager;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author Uno
 */

class SceneScore extends GScene
{
	private var _button:GSpriteButton;
	private var _score:GBitmapText;
	private var _background:GImage;
	
	public function new() 
	{
		super();
		
		_background = new GImage("background_scorecard", GAlignMode.CENTER);
		addEntity(_background);
		
		_button = new GSpriteButton("button_replay", GAlignMode.CENTER, function():Void
		{
			GSceneManager.gotoScreen(SceneGame);
			GSoundManager.stop("lose");
		});
		addEntity(_button);
		
		_button.position.x = Global.replayButtonPosition.x;
		_button.position.y = Global.replayButtonPosition.y;
		
		_button.addOverSound("button_over");
		_button.addDownSound("button_down");
		
		_score = new GBitmapText("font", GTextAlignMode.CENTER);
		_score.text = "Score: " + Global.score;
		_score.position.x = Global.scoreFinalPosition.x;
		_score.position.y = Global.scoreFinalPosition.y;
		addEntity(_score);
		
		GSoundManager.stop("bgm_game");
		GSoundManager.play("lose");
	}
	
	override public function update():Void
	{
		super.update();
		
		if (GKeyboard.isSpace)
		{
			GSceneManager.gotoScreen(SceneGame);
			GSoundManager.stop("lose");
			GSoundManager.play("button_over");
		}
	}
}