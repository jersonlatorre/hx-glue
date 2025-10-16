package;

import glue.Glue;
import demo.scenes.DemoScene;
import platformer.scenes.PlatformerScene;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Glue.run(DemoScene, { showStats: true });
		Glue.run(PlatformerScene, { showStats: true });
	}
}
