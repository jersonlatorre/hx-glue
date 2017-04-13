package;

import glue.Glue;
import scenes.GameScene;
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

		 Glue.load({ type:"image", src:"img/background.png", id:"background" });

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
		});
	}
}