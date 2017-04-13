package scenes;

import glue.display.GImage;
import glue.scene.GScene;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class GameScene extends GScene
{
	var _background:GImage;

	override public function preload():Void
	{
		/**
		 *  Load scene assets here.
		 *  Is it not necessary to load assets in this case because
		 *  all the assets where loaded in the Main class.
		 */
	}

	override public function init():Void
	{
		_background = new GImage("background").addTo(this);

		/**
		 *  Shows a little fadeIn when the scene starts.
		 */
		fadeIn();
	}
	
	override public function update():Void
	{
		
	}
}