package glue.display;

import glue.assets.GLoader;
import glue.utils.GTime;
import glue.utils.GTools;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Rectangle;
import openfl.geom.Point;

/**
 * ...
 * @author Jerson La Torre
 * 
 */

class GSprite extends GEntity
{
	public var animation:String = "";
	var _onEndAnimation:Dynamic = null;
	
	var _animations:Map<String, Dynamic> = new Map<String, Dynamic>();
	var _sprite:__GSpriteBase;
	
	public function new()
	{
		super();
	}

	public function addAnimation(animationId:String, assetId:String, ?fps:Int = 30, ?loop:Bool = true) 
	{
		_animations[animationId] = { id: assetId, fps: fps, loop: loop };
	}

	public function play(name:String)
	{
		if (animation == name) return null;
		
		while (_skin.numChildren > 0)
		{
			_skin.removeChildAt(0);
		}
		
		if (_animations[name] == null)
		{
			throw '${ GTools.getClassName(this) } -> a sprite ID must be provided!';
		}
		
		_sprite = new __GSpriteBase(_animations[name].id, _animations[name].fps, _animations[name].loop);
		_sprite.addToLayer(_skin);
		if (_onEndAnimation != null) _sprite.onEndAnimation(_onEndAnimation);
		
		width = _sprite.width;
		height = _sprite.height;
		animation = name;

		return null;
	}

	public function onEndAnimation(callback:Dynamic)
	{
		_onEndAnimation = callback;
	}
	
	override public function preUpdate() 
	{
		if (_sprite != null) _sprite.preUpdate();
		super.preUpdate();
		// width = _sprite.width;
		// height = _sprite.height;
	}
	
	override public function destroy() 
	{
		_sprite.removeFromLayer(_skin);
		_sprite.destroy();
		super.destroy();
	}
}

@:final class __GSpriteBase extends GEntity
{
	var _framesLength:Int;
	var _currentFrameIndex:Float = 0;
	var _fps:Int;
	var _loop:Bool;
	var _frame:Bitmap;

	// #if CREATE_ONE_ROW_SPRITESHEET
	var _frames:BitmapData;
	// #end

	// #if CACHE_FRAME_PER_FRAME
	// var _frames:Array<BitmapData>;
	// #end

	var _frameBmd:BitmapData;
	var _mask:Shape;
	var _drawRect:Rectangle;
	var _drawPoint:Point;
	var _isPaused:Bool = false;
	var _onEndAnimation:Dynamic = null;
	var rounded:Int = 0;
	
	public function new(assetId:String, fps:Int = 30, loop:Bool = true)
	{
		super();

		_fps = fps;
		_loop = loop;

		_frames = GLoader.getSpritesheet(assetId).frames;

		_framesLength = GLoader.getSpritesheet(assetId).numFrames;
		width = GLoader.getSpritesheet(assetId).width;
		height = GLoader.getSpritesheet(assetId).height;

		// #if CACHE_FRAME_PER_FRAME
		// _drawRect = new Rectangle(0, 0, width, height);
		// _drawPoint = new Point(0, 0);
		// _frameBmd = new BitmapData(Std.int(width), Std.int(height), true, 0x00000000);
		// _frame = new Bitmap(_frameBmd);
		// _skin.addChild(_frame);
		// #end

		// #if CREATE_ONE_ROW_SPRITESHEET
		_frame = new Bitmap(_frames);
		_mask = new Shape();
		_mask.graphics.beginFill(0);
		_mask.graphics.drawRect(0, 0, width, height);
		_mask.graphics.endFill();
		_frame.mask = _mask;
		_skin.addChild(_frame);
		_skin.addChild(_mask);
		// #end
	}
	
	public function onEndAnimation(callback:Dynamic)
	{
		_onEndAnimation = callback;
	}
	
	override public function preUpdate()
	{
		_currentFrameIndex += _fps * GTime.deltaTime;
		
		if(_currentFrameIndex >= _framesLength)
		{
			if (!_loop) _isPaused = true;
			if (_onEndAnimation != null) _onEndAnimation();
		}
		
		rounded = Std.int((_currentFrameIndex) % _framesLength);
		
		// #if CACHE_FRAME_PER_FRAME
		// _frameBmd.fillRect(_drawRect, 0);
		// _frameBmd.draw(_frames[rounded]);
		// #end

		// #if CREATE_ONE_ROW_SPRITESHEET
		if (_frame != null) _frame.x = -rounded * width;
		// #end
	}

	override public function destroy()
	{
		_frame.bitmapData.disposeImage();
		_frame = null;
		_mask = null;
		super.destroy();
	}
}