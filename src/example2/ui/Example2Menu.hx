package example2.ui;

import glue.ui.GSceneManager;
import glue.Glue;
import glue.display.GImage;
import glue.display.GButton;
import glue.ui.GScene;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class Example2Menu extends GScene
{
	var _playButton:GButton;
	var _background:GImage;
	
	public function new()
	{
		super();
		
		trace("hola!");
		_background = new GImage("background_game")
			.addTo(this);

		_playButton = new GButton("button")
			.addTo(this).onClick(function() { GSceneManager.gotoScene(SceneGame); })
			.setPosition(Glue.width / 2, Glue.height / 2)
			.setAnchor(0.5, 0.5);
		
		fadeIn();
	}
	
	override public function update():Void
	{
		super.update();
	}
}