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
		
		var s = new Sprite();
		s.graphics.beginFill();
		
		trace("aaaaaaaaaa");
		
		GLoader.queue({ type:"image", src:"img/background_game.png", id:"background_game" });
		GLoader.queue({ type:"sprite", src:"img/circle_idle", id:"circle_idle" });
		
		GEngine.start({
			stage: stage,
			width: 800,
			height: 600,
			mainScene: SceneGame
		});
	}
}