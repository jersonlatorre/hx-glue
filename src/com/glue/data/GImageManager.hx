package com.glue.data;

import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;

/**
 * ...
 * @author uno
 */

class GImageManager
{
	static var _callback:Dynamic;
	static var _currentFileIndex:Int = 0;
	static var _files:Array<Dynamic> = new Array<Dynamic>();
	static var _loadedImages:Map<String, Bitmap> = new Map<String, Bitmap>();
	
	static var _embeddedImages:Map<String, Bitmap> = new Map<String, Bitmap>();
	
	static public var spriteFrames:Map<String, Array<BitmapData>> = new Map<String, Array<BitmapData>>();
	
	static public function addFile(url:String, id:String):Void
	{
		if (GEngine.isEmbedded)
		{
			var bitmap:Bitmap = new Bitmap(Assets.getBitmapData(url, true));
			_embeddedImages.set(id, bitmap);
		}
		else
		{
			var loader:Loader = new Loader();
			_files.push( { id: id, url: url, loader:loader } );
		}
	}
	
	static public function startDownload(callback:Dynamic):Void
	{
		if (GEngine.isEmbedded)
		{
			callback();
			return;
		}
		
		_callback = callback;
		
		downloadFile();
	}
	
	static function downloadFile(e:Event = null):Void 
	{	
		if (_currentFileIndex > 0)
		{
			_files[_currentFileIndex - 1].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, downloadFile);
			_files[_currentFileIndex - 1].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
			
			bitmapData = cast(_files[_currentFileIndex - 1].loader.content, Bitmap).bitmapData.clone();
			bitmap = new Bitmap(bitmapData);
			bitmap.smoothing = true;
			_loadedImages.set(_files[_currentFileIndex - 1].id, bitmap);
		}
		
		if (_currentFileIndex == _files.length)
		{
			onLoadComplete();
			return;
		}
		
		trace("\timage: " + _files[_currentFileIndex].id);
		
		var request:URLRequest = new URLRequest(_files[_currentFileIndex].url);
		_files[_currentFileIndex].loader.load(request);
		_files[_currentFileIndex].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, downloadFile);
		_files[_currentFileIndex].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		
		
		GLoaderManager.downladedFiles++;
		
		_currentFileIndex++;
	}
	
	static function onError(e:IOErrorEvent):Void
	{
		trace("Error Downloading " + _files[_currentFileIndex - 1].id);
	}
	
	static function onLoadComplete():Void 
	{
		_callback();
	}
	
	static public function getImage(id:String):Bitmap
	{
		if (GEngine.isEmbedded)
		{
			if(_embeddedImages.exists(id))
			{
				var bitmap:Bitmap = new Bitmap(_embeddedImages.get(id).bitmapData.clone());
				bitmap.smoothing = true;
				//bitmap.cacheAsBitmap = true;
				return bitmap;
			}
			else
			{
				throw "Image id: " + id + " not found";
			}
		}
		else
		{
			if(_loadedImages.exists(id))
			{
				var bitmap:Bitmap = new Bitmap(_loadedImages.get(id).bitmapData.clone());
				bitmap.smoothing = true;
				//bitmap.cacheAsBitmap = true;
				return bitmap;
			}
			else
			{
				throw "Image id: " + id + " not found";
			}
		}
	}
	
	static public function setSpriteFrames(id:String)
	{	
		if (!spriteFrames.exists(id))
		{
			var source:Bitmap = GImageManager.getImage(id);
			var data:Dynamic = GDataManager.getJson(id);
			var frames:Array<BitmapData> = new Array<BitmapData>();
			
			for (i in 0...data.frames.length)
			{
				var frameInfo:Dynamic = data.frames[i];
				var imgData:BitmapData = new BitmapData(frameInfo.sourceSize.w, frameInfo.sourceSize.h, true, 0x00FFFFFF);
				imgData.copyPixels(source.bitmapData, new Rectangle(frameInfo.frame.x, frameInfo.frame.y, frameInfo.frame.w, frameInfo.frame.h), new Point(frameInfo.spriteSourceSize.x, frameInfo.spriteSourceSize.y), null, null, false);
				frames.push(imgData);
			}
			
			spriteFrames[id] = frames;
		}
	}
}