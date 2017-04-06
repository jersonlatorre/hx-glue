package;

import example1.Example1;
import glue.data.GLoader;
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

		GLoader.queue({ type:"image", src:"img/background_game.png", id:"background_game"});
		GLoader.queue({ type:"image", src:"img/floor.png", id:"floor"});
		GLoader.queue({ type:"sprite", src:"img/player_idle", id:"player_idle"});

		Glue.start({
			stage: stage,
			width: 1080,
			height: 1920,
			mainScene: Example1
		});
	}
}
