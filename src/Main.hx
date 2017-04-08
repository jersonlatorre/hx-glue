package;

import glue.Glue;
import example1.Example_1;
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
		 *  If is it necessary, you can describe all the assets in one array
		 *  before the game starts. Then you pass all the data to the start() method.
		 *  
		 *  Syntax:
		 *  
		 *  assets:Array<Any> = [
		 *  	{
		 *  		type	:	[ "image" | "spritesheet" | "data" ],
		 *  		src		:	[ Path of the content. ],
		 *  		id		:	[ Name by which the asset will be invoked from the code. ]
		 *  	}];
		 */
		var assets:Array<Any> = [
			{ type:"image", src:"img/background_game.png", id:"background_game" },
			{ type:"image", src:"img/floor.png", id:"floor" },
			{ type:"spritesheet", src:"img/player_idle.png", id:"player_idle" }
		];

		/**
		 *  Starts the game engine.
		 *  
		 *  Syntax:
		 *  
		 *  Glue.start({
		 *  	mainScene (required)	:	[ First Scene from where the engine will start. ],
		 *  	assets (optional)			:	[ The assets array declared beore. ],
		 *  	isDebug (optional)		: [ It will show traces in debugging mode. ]
		 *  });
		 */
		Glue.start({
			mainScene: Example_1,
			assets: assets,
			isDebug: true
		});
	}
}