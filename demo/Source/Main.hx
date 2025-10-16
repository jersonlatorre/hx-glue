package;

import glue.Glue;
import demo.scenes.DemoScene;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		var config = {
			mainScene: cast DemoScene,
			preloader: null,
			isDebug: true,
			showBounds: false,
			showStats: true
		};

		Glue.start(config);
	}
}
