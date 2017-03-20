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

		GEngine.start({
			stage: stage,
			width: 1080,
			height: 1920,
			assets: "./assets.json",
			mainScene: SceneGame
		});
	}
}