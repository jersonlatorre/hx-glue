package com.plug.ui;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import com.glue.data.GDataManager;
import com.glue.data.GImageManager;
import com.glue.data.GLoaderManager;
import com.glue.data.GSoundManager;
import com.glue.entities.GAlignMode;
import com.glue.entities.GBitmapText;
import com.glue.entities.GImage;
import com.glue.entities.GTextAlignMode;
import com.glue.GEngine;
import com.glue.input.GMouse;
import com.glue.ui.GScene;
import com.glue.utils.GVector2D;
import com.plug.entities.Player;
import com.plug.entities.Item;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author Uno
 */

class SceneGame extends GScene
{
	var _player:Player;
	var _items:Array<Item>;
	var _canvasGame:Sprite;
	var _canvasHud:Sprite;
	var _timerGood:Int = 0;
	var _timerBad:Int = 0;
	var _score:GBitmapText;
	var isPaused:Bool = false;
	
	var _background:GImage;
	
	public function new() 
	{
		super();
		
		Global.game = this;
		Global.score = 0;
		
		_canvasGame = new Sprite();
		_canvasHud = new Sprite();
		
		canvas.addChild(_canvasGame);
		canvas.addChild(_canvasHud);
		
		_background = new GImage("background_game", GAlignMode.BOTTOM);
		
		_player = new Player();
		_player.position = GVector2D.create(0, 120);
		
		addLayer("background");
		addLayer("elements");
		addLayer("hud");
		addEntity(_background, "background");
		addEntity(_player, "elements");
		camera.position = GVector2D.create(0, 300);
		//camera.follow(_player);
		
		_items = new Array<Item>();
		
		_score = new GBitmapText("font", GTextAlignMode.LEFT);
		_score.position.x = Global.scoreGamePosition.x;
		_score.position.y = Global.scoreGamePosition.y;
		addEntity(_score, "hud");
		
		fadeIn(0.3);
		
		GSoundManager.loop("bgm_game");
	}
	
	private function createGoodItem()
	{
		var item:Item = new Item("good");
		item.index = Item.count;
		Item.count++;
		addEntity(item, "elements");
		_items.push(item);
	}
	
	private function createBadItem() 
	{
		var item:Item = new Item("bad");
		item.index = Item.count;
		Item.count++;
		addEntity(item, "elements");
		_items.push(item);
	}
	
	override public function update():Void
	{
		createItems();
		checkCollisions();
		removeDeadItems();
		updateScore();
		
		super.update();
	}
	
	function removeDeadItems() 
	{
		var i:Int = 0;
		var item:Item;
		
		while (i < _items.length)
		{
			item = _items[i];
			
			if (item.state == Item.STATE_DEAD)
			{
				removeEntity(item);
				_items.splice(i, 1);
				i--;
			}
			
			i++;
		}
	}
	
	function checkCollisions() 
	{
		var i:Int = 0;
		var item:Item;
		
		while (i < _items.length)
		{
			item = _items[i];
			
			if (item.state == Item.STATE_ALIVE && _player.state == Player.STATE_ALIVE && item.collide(_player))
			{
				item.hit();
				
				if (item.type == "good")
				{
					Global.score++;
					GSoundManager.play("good");
				}
				
				if (item.type == "bad")
				{
					GSoundManager.play("die");
					_player.hit();
					deleteItems();
				}
			}
			
			i++;
		}
	}
	
	function updateScore() 
	{
		_score.text = "Score: " + Global.score;
		_score.update();
	}
	
	function createItems() 
	{
		_timerGood += Std.int(1000 / GEngine.stage.frameRate);
		
		if (_timerGood >= 1000)
		{
			_timerGood = 0;
			
			if (_player.animation != "die")
			{
				createGoodItem();
			}
		}
		
		_timerBad += Std.int(1000 / GEngine.stage.frameRate);
		
		if (_timerBad >= 300)
		{
			_timerBad = 0;
			
			if (_player.animation != "die")
			{
				createBadItem();
			}
		}
	}
	
	private function deleteItems() 
	{
		for (i in 0..._items.length)
		{
			var item:Item = _items[i];
			Actuate.tween(item, 0.5, { alpha: 0 } ).ease(Quad.easeOut);
		}
	}
}