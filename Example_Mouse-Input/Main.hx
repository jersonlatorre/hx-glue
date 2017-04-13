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
		 *  
		 *  Syntax:
		 *  
		 *  Glue.load(
		 *  	{
		 *  		type	:	[ "image" | "spritesheet" | "button" | data" ],
		 *  		src		:	[ Path of the content. ],
		 *  		id		:	[ Name by which the asset will be invoked from the code. ]
		 *  	}
		 *  );
		 */

		 Glue.load({ type:"image", src:"img/background_game.png", id:"background_game" });
		 Glue.load({ type:"image", src:"img/floor.png", id:"floor" });
		 Glue.load({ type:"spritesheet", src:"img/character_idle.png", id:"character_idle" });

		/**
		 *  Starts the game engine.
		 *  
		 *  Syntax:
		 *  
		 *  Glue.start({
		 *  	mainScene (required)	:	[ First Scene from where the engine will start. ],
		 *  	isDebug (optional)		: [ It will show traces in debugging mode. ]
		 *  });
		 */
		Glue.start({
			mainScene: GameScene,
			isDebug: true
		});
	}
}