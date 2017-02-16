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
		// GLoader.queue({ type:"data", src:"data/config.json", id:"config" });
		GLoader.queue({ type:"atlas", src:"img/world.png", data:"img/world.json", id:"world" });
		
		trace("hola");

		GEngine.start({
			stage: stage,
			width: 800,
			height: 600,
			mainScene: SceneGame,
		});

		// this.graphics.beginFill(0xFFFFFF);
		// this.graphics.drawCircle(0, 0, 100);
		// this.graphics.endFill();
	}
}
