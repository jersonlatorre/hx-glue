package;

import glue.display.GBitmapTextAlign;
import glue.display.GBitmapText;
import glue.display.GImage;
import glue.display.GSprite;
import glue.input.GInput;
import glue.Glue;
import glue.math.GVector2D;
import glue.scene.GScene;
import glue.utils.GTime;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class GameScene extends GScene
{
	var GRAVITY:GVector2D = GVector2D.create(0, 800);
	var JUMP_IMPULSE:GVector2D = GVector2D.create(0, -800);
	var FLOOR_Y:Float;

	var _background:GImage;
	var _floor:GImage;
	var _player:GSprite;

	override public function preload()
	{
		/**
		 *  Load scene assets here.
		 *  Is it not necessary to load assets in this case because
		 *  all the assets where loaded in the Main class.
		 */
	}

	override public function init()
	{
		/**
		 *  Create an image and add it to the world.
		 */
		 var _background = new GImage();
		_background.createFromAsset("background_game");
		add(_background);


		/**
		 *  Create an image and change it's position.
		 */
		_floor = new GImage();
		_floor.createFromAsset("floor");
		_floor.setPosition(0, Glue.height - _floor.height);
		FLOOR_Y = Glue.height - _floor.height;
		add(_floor);


		/**
		 *  Create a sprite and change some properties.
		 */
		_player = new GSprite();
		_player.addAnimation("idle", "character_idle");
		_player.play("idle");
		_player.setAnchor(0.5, 1);
		_player.setPosition(250, 250);
		_player.acceleration = GRAVITY;
		add(_player);


		/**
		 *  Creates a bitmap text.
		 */
		var bitmapText = GBitmapText.fromAngelCode("font_bitmap", "font_data");
		// var bitmapText = GBitmapText.fromMonospace("font_monospace", "!     :() ,?.ABCDEFGHIJKLMNOPQRSTUVWXYZ", 16, 16)
		bitmapText.text = "HELLO,\nSEXY GLUE!";
		bitmapText.alignment = GBitmapTextAlign.CENTER;
		bitmapText.setAnchor(0.5, 0.5);
		bitmapText.setPosition(Glue.width / 2, 130);
		add(bitmapText);


		/**
		 *  Shows a little fadeIn when the scene starts.
		 */
		fadeIn();
	}
	
	override public function update()
	{
		/**
		 *  Move the player following the mouse.
		 */
		 _player.position.x += 0.04 * (GInput.mousePosition - _player.position).x;
		

		/**
		 *  Jump!
		 */
		if (_player.position.y > FLOOR_Y)
		{
			_player.position.y = FLOOR_Y;
			_player.velocity = JUMP_IMPULSE;
		}


		/**
		 *  Reset the game.
		 */
		if (GInput.isMouseDown)
		{
			gotoScene(GameScene);
		}
	}
}