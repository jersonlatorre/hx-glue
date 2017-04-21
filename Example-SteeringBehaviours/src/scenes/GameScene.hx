package scenes;

import glue.scene.GScene;
import entities.Agent;
import entities.Target;

/**
 * ...
 * @author Jerson La Torre
 *
 */

class GameScene extends GScene
{
	var _agent = new Agent();
	var _target = new Target();

	override public function preload()
	{
		/**
		 *  Load scene assets here.
		 */
	}

	override public function init()
	{
		createBackground(0xDDDDDD);

		_agent = new Agent();
		_target = new Target();

		add(_agent);
		add(_target);

		_agent.setTarget(_target);

		fadeIn();
	}
	
	override public function update()
	{
	}
}