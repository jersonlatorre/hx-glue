package demo.scenes;

import demo.entities.FallingItem;
import demo.entities.Player;
import demo.ui.ScoreLabel;
import glue.Glue;
import glue.scene.GScene;
import glue.utils.GTime;
import glue.display.GEntityGroup;
import glue.input.InputActions;
import glue.math.GVector2D;
import openfl.ui.Keyboard;

/**
 * Modern version of DemoScene showcasing new architecture features
 * Compare with DemoScene.hx to see the improvements
 */
class ModernDemoScene extends GScene
{
	var player:Player;
	var scoreLabel:ScoreLabel;
	var items:GEntityGroup<FallingItem>;
	var spawnTimer:Float = 0;
	var spawnInterval:Float = 1.0;
	var score:Int = 0;

	override public function init()
	{
		addLayer("entities");
		addLayer("hud");

		// Modern input setup with preset
		InputActions.create()
			.action("move_left", [Keyboard.LEFT, Keyboard.A])
			.action("move_right", [Keyboard.RIGHT, Keyboard.D])
			.apply();

		// Fluent API for entity creation
		player = add(new Player()
			.at(Glue.width * 0.5, Glue.height - 80),
			"entities");

		// Entity groups for automatic management
		items = new GEntityGroup(this, "entities");

		scoreLabel = add(new ScoreLabel()
			.at(20, 20),
			"hud");
		scoreLabel.setScore(score);
	}

	override public function update()
	{
		// Timer logic
		spawnTimer += GTime.deltaTime;
		if (spawnTimer >= spawnInterval)
		{
			spawnTimer -= spawnInterval;
			spawnFallingItem();
			if (spawnInterval > 0.4) spawnInterval -= 0.02;
		}

		// Automatic cleanup of destroyed entities
		items.cleanup();

		// Simple collision detection with group
		var hit = items.collidesWith(player);
		if (hit != null)
		{
			handleCatch(hit);
		}

		// Filter out items below screen
		var offscreen = items.filter(item ->
			item.position.y - item.height * item.anchor.y > Glue.height + 40
		);

		for (item in offscreen)
		{
			items.destroy(item);
		}
	}

	function spawnFallingItem()
	{
		// Fluent API with implicit vector conversion
		items.add(new FallingItem()
			.at(20 + Math.random() * (Glue.width - 40), -30));
	}

	function handleCatch(item:FallingItem)
	{
		score++;
		scoreLabel.setScore(score);
		items.destroy(item);
	}
}
