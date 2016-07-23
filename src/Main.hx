package;

import com.glue.GEngine;
import com.glue.data.GLoader;
import com.plug.ui.SceneGame;
import openfl.display.Sprite;

/**
 * ...
 * @author Uno
 */
class Main extends Sprite 
{
	public function new()
	{
		super();
		
		GLoader.queue({ type:"image", src:"img/background_game.png", id:"background_game" });
		GLoader.queue({ type:"image", src:"img/play.png", id:"image" });
		
		GEngine.start({
			stage: stage,
			width: 800,
			height: 600,
			mainScene: SceneGame,
		});
	}
}
