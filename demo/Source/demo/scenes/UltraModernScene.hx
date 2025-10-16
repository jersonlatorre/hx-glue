package demo.scenes;

import demo.entities.FallingItem;
import demo.entities.Player;
import demo.ui.ScoreLabel;
import glue.Glue;
import glue.scene.Scene;
import glue.display.Group;
import openfl.ui.Keyboard;

/**
 * ULTRA-MODERN version - Maximum convenience!
 * ZERO imports needed for common operations!
 * Everything is accessible directly from scene
 */
class UltraModernScene extends Scene
{
	var player:Player;
	var scoreLabel:ScoreLabel;
	var items:Group<FallingItem>;
	var spawnTimer:Float = 0;
	var spawnInterval:Float = 1.0;
	var score:Int = 0;

	override public function init()
	{
		// Consistent API - everything is add*()
		addLayer("entities");
		addLayer("hud");

		// NO MORE: InputActions.create().action()...
		// Just addAction() - consistent with addLayer()!
		addWASDAndArrows(); // ← Preset, o...

		addAction("jump", [Keyboard.SPACE]); // ← Individual actions

		// Fluent entity creation
		player = add(new Player()
			.at(Glue.width * 0.5, Glue.height - 80),
			"entities");

		items = new Group(this, "entities");

		scoreLabel = add(new ScoreLabel()
			.at(20, 20),
			"hud");
		scoreLabel.setScore(score);
	}

	override public function update()
	{
		// NO MORE: import glue.utils.Time;
		// deltaTime is available directly!
		spawnTimer += deltaTime; // ← Sin import!
		if (spawnTimer >= spawnInterval)
		{
			spawnTimer -= spawnInterval;
			spawnFallingItem();
			if (spawnInterval > 0.4) spawnInterval -= 0.02;
		}

		items.cleanup();

		var hit = items.collidesWith(player);
		if (hit != null)
		{
			handleCatch(hit);
		}

		// Clean offscreen items
		var offscreen = items.filter(item ->
			item.position.y - item.height * item.anchor.y > Glue.height + 40
		);
		for (item in offscreen) items.destroy(item);
	}

	function spawnFallingItem()
	{
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
