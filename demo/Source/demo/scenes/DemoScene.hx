package demo.scenes;

import demo.entities.FallingItem;
import demo.entities.Player;
import demo.ui.ScoreLabel;
import glue.Glue;
import glue.scene.Scene;
import glue.utils.Time;
import glue.input.Input;
import openfl.ui.Keyboard;

class DemoScene extends Scene
{
	var player:Player;
	var scoreLabel:ScoreLabel;
	var items:Array<FallingItem> = [];
	var spawnTimer:Float = 0;
	var spawnInterval:Float = 1.0;
	var score:Int = 0;

	override public function init()
	{
		addLayer("entities");
		addLayer("hud");

		Input.bindKeys("move_left", [Keyboard.LEFT, Keyboard.A]);
		Input.bindKeys("move_right", [Keyboard.RIGHT, Keyboard.D]);

		player = new Player();
		player.position.set(Glue.width * 0.5, Glue.height - 80);
		add(player, "entities");

		scoreLabel = new ScoreLabel();
		scoreLabel.position.set(20, 20);
		scoreLabel.setScore(score);
		add(scoreLabel, "hud");
	}

	override public function update()
	{
		spawnTimer += Time.deltaTime;
		if (spawnTimer >= spawnInterval)
		{
			spawnTimer -= spawnInterval;
			spawnFallingItem();
			if (spawnInterval > 0.4) spawnInterval -= 0.02;
		}

		var i = items.length - 1;
		while (i >= 0)
		{
			var item = items[i];

			if (item.destroyed)
			{
				items.splice(i, 1);
			}
			else if (player.collideWith(item))
			{
				handleCatch(item, i);
			}
			else if (item.position.y - item.height * item.anchor.y > Glue.height + 40)
			{
				remove(item);
				item.destroy();
				items.splice(i, 1);
			}

			i--;
		}
	}

	function spawnFallingItem()
	{
		var item = new FallingItem();
		item.position.set(20 + Math.random() * (Glue.width - 40), -item.height);
		add(item, "entities");
		items.push(item);
	}

	function handleCatch(item:FallingItem, index:Int)
	{
		score++;
		scoreLabel.setScore(score);

		remove(item);
		item.destroy();
		items.splice(index, 1);
	}
}
