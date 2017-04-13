package;

import glue.Glue;
import scenes.MenuScene;
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
		 */
		 
		Glue.start({
			mainScene: MenuScene,
			isDebug: true
		});
	}
}