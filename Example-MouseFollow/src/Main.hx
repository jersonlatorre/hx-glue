package;

import glue.Glue;
import GameScene;
import openfl.display.Sprite;

/**
 * ...
 * @author Jerson La Torre
 */

class Main extends Sprite
{
	public function new()
	{
		super();

		/**
		 *  You can preload all your assets before the game starts.
		 */

		 Glue.loadImage("background_game", "images/background_game.png");
		 Glue.loadImage("floor", "images/floor.png");
		 Glue.loadImage("font_bitmap", "fonts/font.png");
		 Glue.loadData("font_data", "fonts/font.fnt");
		 Glue.loadImage("font_monospace", "fonts/monospace.png");
		 Glue.loadSpritesheet("character_idle", "images/character_idle.png");

		/**
		 *  Starts the game engine.
		 *  
		 *  Syntax:
		 *  
		 *  Glue.start({
		 *  	mainScene (required)	:	[ First Scene from where the engine will start. ],
		 *  	isDebug (optional)		: [ It will show traces in debugging mode. ]
		 *  	showStats (optional)	: [ It will show FPS and memory stats. ]
		 *  });
		 */

		Glue.start({
			mainScene: GameScene,
			isDebug: true,
			showStats: true
		});
	}
}