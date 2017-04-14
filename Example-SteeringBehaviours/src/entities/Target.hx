package entities;

import glue.input.GMouse;
import glue.display.GEntity;

/**
 * ...
 * @author Jerson La Torre
 */

class Target extends GEntity
{
	override public function init()
	{
		createCircleGraphic(18, 0xFF0000);
		setAnchor(0.5, 0.5);
	}

	override public function update()
	{
		position = GMouse.position;
	}
}