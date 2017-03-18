package;

import com.glue.GEngine;
import com.glue.data.GLoader;
import com.plug.ui.SceneGame;
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
		
		GLoader.queue({ type:"image", src:"img/background_game.png", id:"background_game" });
		GLoader.queue({ type:"image", src:"img/floor.png", id:"floor" });
		GLoader.queue({ type:"sprite", src:"img/player_idle", id:"player_idle" });
		
		GEngine.start({
			stage: stage,
			width: 1080,
			height: 1920,
			mainScene: SceneGame
		});
	}
}