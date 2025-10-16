package glue.display;

import glue.assets.Loader;
import glue.utils.Time;
import glue.utils.Signal;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;

typedef AnimationConfig =
{
	var id:String;
	var fps:Int;
	var loop:Bool;
}

private typedef AnimationState =
{
	var frames:Array<Int>;
	var tileset:Tileset;
	var fps:Int;
	var loop:Bool;
	var framePointer:Float;
	var completed:Bool;
}

class Sprite extends Entity
{
	public var animation:String = "";

	public final onEndAnimation:Signal0 = new Signal0();

	var _animations:Map<String, AnimationConfig> = new Map<String, AnimationConfig>();
	var _tilemap:Tilemap;
	var _tile:Tile;
	var _state:AnimationState;

	public function new()
	{
		super();
	}

	public function addAnimation(animationId:String, assetId:String, ?fps:Int = 30, ?loop:Bool = true):Void
	{
		_animations.set(animationId, { id: assetId, fps: fps, loop: loop });
	}

	public function play(name:String):Void
	{
		if (animation == name) return;

		var config = _animations.get(name);
		if (config == null)
		{
			throw '${ name } animation is not registered.';
		}

		var data:Dynamic = Loader.getSpritesheet(config.id);
		var tileset:Tileset = data.tileset;
		var frames:Array<Int> = data.frameIds;
		var frameWidth:Int = data.width;
		var frameHeight:Int = data.height;
		if (frames.length == 0)
		{
			throw 'Spritesheet \'' + config.id + '\' has no frames.';
		}

		if (_tilemap != null && _tilemap.parent == _skin)
		{
			_skin.removeChild(_tilemap);
		}

		_tilemap = new Tilemap(frameWidth, frameHeight, tileset);
		_tile = new Tile(frames[0], 0, 0);
		_tilemap.addTile(_tile);
		_skin.addChild(_tilemap);

		width = frameWidth;
		height = frameHeight;
		bounds.setTo(-width * anchor.x, -height * anchor.y, width, height);

		_state = {
			frames: frames,
			tileset: tileset,
			fps: config.fps,
			loop: config.loop,
			framePointer: 0,
			completed: false
		};

		animation = name;
	}

	override public function preUpdate():Void
	{
		if (_state != null && _state.frames.length > 0)
		{
			_state.framePointer += _state.fps * Time.deltaTime;
			var total = _state.frames.length;
			var pointer = Std.int(_state.framePointer);

			if (pointer >= total)
			{
				if (_state.loop)
				{
					_state.framePointer = _state.framePointer % total;
					pointer = Std.int(_state.framePointer);
					onEndAnimation.dispatch();
					_state.completed = false;
				}
				else
				{
					_state.framePointer = total - 1;
					pointer = total - 1;
					if (!_state.completed)
					{
						_state.completed = true;
						onEndAnimation.dispatch();
					}
				}
			}

			_tile.id = _state.frames[pointer];
		}

		super.preUpdate();
	}

	override public function destroy():Void
	{
		if (_tilemap != null && _tilemap.parent == _skin)
		{
			_skin.removeChild(_tilemap);
		}
		_tilemap = null;
		_tile = null;
		_state = null;

		onEndAnimation.clear();

		super.destroy();
	}
}
