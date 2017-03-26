package com.plug.ui;

import com.glue.ui.GSceneManager;
import com.glue.Glue;
import com.glue.display.GImage;
import com.glue.display.GButton;
import com.glue.ui.GScene;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class SceneMenu extends GScene
{
	var _playButton:GButton;
	var _background:GImage;
	
	public function new()
	{
		super();

		_background = new GImage("background_game")
			.addTo(this);

		_playButton = new GButton("button")
			.addTo(this).onClick(onPlayClick)
			.setPosition(Glue.width / 2, Glue.height / 2)
			.setAnchor(0.5, 0.5);
		
		fadeIn();
	}
	
	function onPlayClick():Void
	{
		GSceneManager.gotoScene(SceneGame);
	}

	override public function update():Void
	{
		super.update();
	}
}