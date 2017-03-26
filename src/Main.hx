package;

import com.glue.data.GLoader;
import com.glue.Glue;
import com.plug.ui.SceneMenu;
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
		GLoader.queue({ type:"image", src:"img/background_game2.png", id:"background_game2"});
		GLoader.queue({ type:"image", src:"img/floor.png", id:"floor"});
		GLoader.queue({ type:"image", src:"img/floor2.png", id:"floor2"});
		GLoader.queue({ type:"sprite", src:"img/player_idle", id:"player_idle"});
		GLoader.queue({ type:"sprite", src:"img/button", id:"button"});

		Glue.start({
			stage: stage,
			width: 1080,
			height: 1920,
			mainScene: SceneMenu
		});
	}
}
