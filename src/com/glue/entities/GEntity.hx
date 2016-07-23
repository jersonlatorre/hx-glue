package com.glue.entities;
import com.glue.utils.GRectBounds;
import com.glue.utils.GVector2D;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author uno
 * 
 */

@final class GEntity
{
	public var canvas:Sprite;
	public var _content:Sprite;
	public var parent:Sprite;
	public var layerName:String = "";
	
	public var position:GVector2D;
	
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var alpha:Float = 1;
	
	public var width:Float = 0;
	public var height:Float = 0;
	
	public var bounds:GRectBounds;
	
	var _alignType:Int;
	var _debugCanvas:Sprite;
	
	public function new(alignType:Int = 0):Void
	{
		#if html5
		if (alignType == null) alignType = 0;
		#end
		
		canvas = new Sprite();
		_content = new Sprite();
		_debugCanvas = new Sprite();
		
		canvas.addChild(_content);
		canvas.addChild(_debugCanvas);
		
		_alignType = alignType;
		
		
		position = new GVector2D(0, 0);
		bounds = new GRectBounds(0, 0, 0, 0);
	}
	
	public function addEntity(entity:GEntity):Void
	{
		canvas.addChild(entity.canvas);
		canvas.addChild(entity._debugCanvas);
	}
	
	public function removeEntity(entity:GEntity):Void
	{
		canvas.removeChild(entity.canvas);
		canvas.removeChild(entity._debugCanvas);
	}
	
	public function addToWorldLayer(layer:Sprite) 
	{
		layer.addChild(canvas);
		layer.addChild(_debugCanvas);
	}
	
	public function removeFromWorldLayer(layer:Sprite) 
	{
		layer.removeChild(canvas);
		layer.removeChild(_debugCanvas);
	}
	
	public function setBounds(left:Float, top:Float, w:Float, h:Float):Void 
	{
		bounds = new GRectBounds(left, top, w, h);
		if (GEngine.isDebug) drawDebug();
	}
	
	function drawDebug() 
	{
		_debugCanvas.graphics.lineStyle(2, 0xFF0000);
		_debugCanvas.graphics.drawRect(bounds.left, -bounds.top, bounds.width, bounds.height);
		_debugCanvas.graphics.drawCircle(0, 0, 3);
	}
	
	public function update():Void 
	{
		switch(_alignType)
		{
			case GAlignMode.CENTER:
			{
				_content.x = -_content.width / 2;
				_content.y = -_content.height / 2;
			}
			
			case GAlignMode.TOP_LEFT:
			{
				_content.x = 0;
				_content.y = 0;
			}
			
			case GAlignMode.BOTTOM:
			{
				_content.x = -_content.width / 2;
				_content.y = -_content.height;
			}
		}
		
		canvas.x = position.x;
		canvas.y = -position.y;
		canvas.scaleX = scaleX;
		canvas.scaleY = scaleY;
		canvas.alpha = alpha;
		
		_debugCanvas.x = position.x;
		_debugCanvas.y = -position.y;
		_debugCanvas.scaleX = scaleX;
		_debugCanvas.scaleY = scaleY;
		_debugCanvas.alpha = alpha;
		
		width = canvas.width;
		height = canvas.height;
	}
	
	public function collide(entity:GEntity) 
	{
		if (position.x + bounds.left > entity.position.x + entity.bounds.right)
		{
			return false;
		}
		if (position.x + bounds.right < entity.position.x + entity.bounds.left)
		{
			return false;
		}
		if (position.y + bounds.top < entity.position.y + entity.bounds.bottom)
		{
			return false;
		}
		if (position.y + bounds.bottom > entity.position.y + entity.bounds.top)
		{
			return false;
		}
		
		return true;
	}
	
	public function destroy():Void
	{
		
		while (canvas.numChildren > 0)
		{
			canvas.removeChildAt(0);
		}
		
		canvas = null;
	}
}