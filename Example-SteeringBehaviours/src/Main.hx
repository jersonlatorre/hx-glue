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
			showStats: true
		});
	}
}