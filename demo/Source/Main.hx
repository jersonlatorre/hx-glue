package;

import glue.Glue;
import demo.scenes.DemoScene;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Glue.run(DemoScene, { showStats: true });
	}
}
