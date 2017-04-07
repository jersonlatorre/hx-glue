package;

import example1.Example1;
import glue.Glue;
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
		 * All assets in one loading process. 
		 */
		var assets:Array<Any> = [
			{ type:"image", src:"img/background_game.png", id:"background_game" }
			// { type:"image", src:"img/floor.png", id:"floor" },
			// { type:"sprite", src:"img/player_idle", id:"player_idle" }
		];

		Glue.start({
			mainScene: Example1,
			assets: assets,
			isDebug: true
		});
	}
}