package com.glue.entities;

import com.glue.data.GImageManager;
import com.glue.data.GSoundManager;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * ...
 * @author guarajeno
 */

class GSpriteButton extends GEntity
{
	var _id:String;
	var _image:Bitmap;
	//var _hitArea:Sprite;
	//var _hitAreaBmp:Bitmap;
	var _callback:Dynamic;
	
	var _overSoundId:String = "";
	var _downSoundId:String = "";
	
	public function new(id:String, alignType:Int, callback:Dynamic):Void
	{
		super(alignType);
		
		_id = id;
		GImageManager.setSpriteFrames(id);
		
		_callback = callback;
		
		_image = new Bitmap(GImageManager.spriteFrames.get(_id)[0].clone());
		_image.smoothing = true;
		_content.addChild(_image);
		
		//_hitAreaBmp = new Bitmap(_spriteFrames[3]);
		//_hitAreaBmp.pixelSnapping = PixelSnapping.ALWAYS;
		
		//_hitArea = new Sprite();
		//_hitArea.addChild(_hitAreaBmp);
		//addChild(_hitArea);
		//_hitArea.alpha = 0;
		
		_content.buttonMode = true;
		//_content.hitArea = _hitArea;
		
		_content.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		_content.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		_content.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_content.addEventListener(MouseEvent.CLICK, onMouseClick);
	}
	
	function onMouseClick(e:MouseEvent):Void 
	{
		_callback();
	}
	
	function onMouseUp(e:MouseEvent):Void 
	{
		if (_image != null) _image.bitmapData = GImageManager.spriteFrames.get(_id)[0].clone();
	}
	
	function onMouseDown(e:MouseEvent):Void 
	{
		if (_downSoundId != "")
		{
			GSoundManager.play(_downSoundId);
		}
		
		if (_image != null) _image.bitmapData = GImageManager.spriteFrames.get(_id)[2].clone();
	}
	
	function onMouseOut(e:MouseEvent):Void 
	{
		if (_image != null) _image.bitmapData = GImageManager.spriteFrames.get(_id)[0].clone();
	}
	
	function onMouseOver(e:MouseEvent):Void 
	{
		if (_overSoundId != "")
		{
			GSoundManager.play(_overSoundId);
		}
		
		if (_image != null) _image.bitmapData = GImageManager.spriteFrames.get(_id)[1].clone();
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function addOverSound(id:String) 
	{
		_overSoundId = id;
	}
	
	public function addDownSound(id:String) 
	{
		_downSoundId = id;
	}
	
	override public function destroy():Void 
	{
		_content.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		_content.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		_content.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_content.addEventListener(MouseEvent.CLICK, onMouseClick);
		
		super.destroy();
		_image.bitmapData.dispose();
		_image = null;
	}
	
	function playOverSound(e:MouseEvent)
	{
		GSoundManager.play(_overSoundId);
	}
	
	function playDownSound(e:MouseEvent)
	{
		GSoundManager.play(_downSoundId);
	}
}

