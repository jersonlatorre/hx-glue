package platformer.scenes;

import glue.scene.Scene;
import glue.GlueContext;
import glue.display.Group;
import platformer.entities.Player;
import platformer.entities.Platform;
import platformer.entities.Enemy;
import openfl.ui.Keyboard;

class PlatformerScene extends Scene
{
	var player:Player;
	var platforms:Group<Platform>;
	var enemies:Group<Enemy>;

	public function new(context:GlueContext)
	{
		super(context);
	}

	override public function init()
	{
		addWASDAndArrows();
		addAction("jump", [Keyboard.SPACE, Keyboard.UP, 87]);

		platforms = new Group<Platform>(this);
		enemies = new Group<Enemy>(this);

		createLevel();
		createPlayer();
		createEnemies();
	}

	function createLevel()
	{
		var ground = platforms.add(new Platform(800, 50, 0x228B22));
		ground.at(0, context.height - 50);

		var platform1 = platforms.add(new Platform(200, 20, 0x8B4513));
		platform1.at(150, 400);

		var platform2 = platforms.add(new Platform(150, 20, 0x8B4513));
		platform2.at(450, 300);

		var platform3 = platforms.add(new Platform(180, 20, 0x8B4513));
		platform3.at(100, 200);
	}

	function createPlayer()
	{
		player = new Player();
		player.at(100, 400);
		add(player);
	}

	function createEnemies()
	{
		var enemy1 = enemies.add(new Enemy());
		enemy1.at(300, 400);

		var enemy2 = enemies.add(new Enemy());
		enemy2.at(500, 300);
		enemy2.direction = 1;
	}

	override public function update()
	{
		checkPlatformCollisions();
		checkEnemyCollisions();
		checkEnemyPlatformCollisions();
		constrainPlayerToScreen();
	}

	function checkPlatformCollisions()
	{
		player.isOnGround = false;

		for (platform in platforms)
		{
			if (player.velocity.y >= 0)
			{
				var playerBottom = player.position.y;
				var playerLeft = player.position.x - player.width * 0.5;
				var playerRight = player.position.x + player.width * 0.5;

				var platformTop = platform.getTop();

				if (playerBottom >= platformTop &&
					playerBottom <= platformTop + 10 &&
					playerRight > platform.getLeft() &&
					playerLeft < platform.getRight())
				{
					player.landOnGround(platformTop);
				}
			}
		}
	}

	function checkEnemyCollisions()
	{
		for (enemy in enemies)
		{
			if (enemy.isDead) continue;

			if (player.collideWith(enemy))
			{
				var playerBottom = player.position.y;
				var enemyTop = enemy.position.y - enemy.height;

				if (player.velocity.y > 0 && playerBottom < enemyTop + 10)
				{
					enemy.die();
					player.velocity.y = -300;
					trace("Enemy defeated!");
				}
				else
				{
					trace("Player hit! Game Over");
					player.position.set(100, 400);
					player.velocity.set(0, 0);
				}
			}
		}
	}

	function checkEnemyPlatformCollisions()
	{
		for (enemy in enemies)
		{
			if (enemy.isDead) continue;

			for (platform in platforms)
			{
				if (enemy.velocity.y >= 0)
				{
					var enemyBottom = enemy.position.y;
					var enemyLeft = enemy.position.x - enemy.width * 0.5;
					var enemyRight = enemy.position.x + enemy.width * 0.5;

					var platformTop = platform.getTop();

					if (enemyBottom >= platformTop &&
						enemyBottom <= platformTop + 10 &&
						enemyRight > platform.getLeft() &&
						enemyLeft < platform.getRight())
					{
						enemy.position.y = platformTop;
						enemy.velocity.y = 0;
						enemy.acceleration.y = 0;
					}
				}

				var enemyLeft = enemy.position.x - enemy.width * 0.5;
				var enemyRight = enemy.position.x + enemy.width * 0.5;

				if ((enemyRight > platform.getRight() || enemyLeft < platform.getLeft()))
				{
					var centerY = enemy.position.y - enemy.height * 0.5;
					if (centerY > platform.getTop() && centerY < platform.getBottom())
					{
						enemy.changeDirection();
					}
				}
			}

			if (enemy.position.x < 0 || enemy.position.x > context.width)
			{
				enemy.changeDirection();
			}
		}
	}

	function constrainPlayerToScreen()
	{
		if (player.position.x < 0)
		{
			player.position.x = 0;
		}
		else if (player.position.x > context.width)
		{
			player.position.x = context.width;
		}

		if (player.position.y > context.height + 100)
		{
			player.position.set(100, 400);
			player.velocity.set(0, 0);
			trace("Fell off! Respawn");
		}
	}
}
