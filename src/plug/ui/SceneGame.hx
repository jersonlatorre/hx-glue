package plug.ui;

import glue.utils.GVector2D;
import glue.utils.GTime;
import glue.ui.GSceneManager;
import glue.Glue;
import glue.display.GSprite;
import glue.display.GImage;
import glue.display.GButton;
import glue.ui.GScene;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class SceneGame extends GScene
{
	// var _background:GImage;
	// var _floor:GImage;
	// var _player:GSprite;
	// var _playButton:GButton;
	
	public function new()
	{
		super();

		trace("hola!");

		// addLayer("world");
		// addLayer("ui");

		// _background = new GImage("background_game")
		// 	.setAnchor(0, 0).addTo(this, "world");

		// _floor = new GImage("floor2")
		// 	.setPosition(0, Glue.height - 250)
		// 	.addTo(this, "world");

		// _playButton = new GButton("button")
		// 	.addTo(this, "ui").onClick(function(){GSceneManager.gotoScene(SceneMenu);})
		// 	.setPosition(Glue.width / 2, Glue.height / 2)
		// 	.setAnchor(0.5, 0.5);

		// _player = new GSprite()
		// 	.addAnimation("player_idle")
		// 	.setAnchor(0.5, 1)
		// 	.play()
		// 	.setPosition(200, 200)
		// 	.addTo(this, "world");

		// camera.follow(_player)
		// 	.setBottomLimit(Glue.height)
		// 	.setLeftLimit(0)
		// 	.setRightLimit(Glue.width);

		// fadeIn();
	}
	
	override public function update():Void
	{
		// _player.velocity += new GVector2D(0, 800) * GTime.deltaTime;
		// _player.position += _player.velocity * GTime.deltaTime;
		
		// if (_player.position.y >= 1500)
		// {
		// 	_player.velocity = new GVector2D(0, -1000);
		// }
		
		// super.update();
	}
}