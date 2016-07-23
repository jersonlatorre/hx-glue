package com.glue.data;

import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author uno
 */

class GLoader
{
	static var _callback:Dynamic;
	static var _currentFileIndex:Int = 0;
	static var _files:Array<Dynamic> = new Array<Dynamic>();
	static var _loadedFiles:Map<String, Dynamic> = new Map<String, Dynamic>();
	static public var downloadedFiles = 0;
	static public var totalFiles = 0;
	
	static public function queue(data:Dynamic):Void
	{
		totalFiles++;
		
		if (data.type == "image")
		{
			var loader:Loader = new Loader();
			_files.push( { type:data.type, id: data.id, url: data.src, loader:loader } );
		}
		else if (data.type == "atlas")
		{
			var loader1:Loader = new Loader();
			_files.push( { type: "image", id: data.id, url: data.src, loader:loader1 } );
			
			var loader2:URLLoader = new URLLoader();
			_files.push( { type: "data", id: data.id + "_data", url: data.data, loader:loader2 } );
		}
		else
		{
			var loader:URLLoader = new URLLoader();
			_files.push( { type:data.type, id: data.id, url: data.src, loader:loader } );
		}
	}
	
	static public function load(callback:Dynamic):Void
	{
		_callback = callback;
		downloadFile();
	}
	
	static function downloadFile(e:Event = null):Void 
	{	
		if (_currentFileIndex > 0)
		{
			if (_files[_currentFileIndex - 1].type == "image")
			{
				_files[_currentFileIndex - 1].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, downloadFile);
				_files[_currentFileIndex - 1].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				var data = _files[_currentFileIndex - 1].loader.content;
				_loadedFiles.set(_files[_currentFileIndex - 1].id, data);
			}
			else
			{
				_files[_currentFileIndex - 1].loader.removeEventListener(Event.COMPLETE, downloadFile);
				_files[_currentFileIndex - 1].loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				var data = _files[_currentFileIndex - 1].loader.data;
				_loadedFiles.set(_files[_currentFileIndex - 1].id, data);
			}
		}
		
		if (_currentFileIndex == _files.length)
		{
			onLoadComplete();
			return;
		}
		
		trace("file: " + _files[_currentFileIndex].id);
		
		if (_files[_currentFileIndex].type == "image")
		{
			_files[_currentFileIndex].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, downloadFile);
			_files[_currentFileIndex].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		else
		{
			_files[_currentFileIndex].loader.addEventListener(Event.COMPLETE, downloadFile);
			_files[_currentFileIndex].loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		_files[_currentFileIndex].loader.load(new URLRequest(_files[_currentFileIndex].url));
		
		
		GLoader.downloadedFiles++;
		
		_currentFileIndex++;
	}
	
	static function onError(e:IOErrorEvent)
	{
		trace("Error Downloading " + _files[_currentFileIndex - 1].id + " " + e);
	}
	
	static function onLoadComplete():Void 
	{
		_callback();
	}
	
	static public function getImage(id:String):Bitmap
	{
		if (!_loadedFiles.exists(id))
		{
			trace("Image with the id: " + id + " not found.");
			return null;
		}
		else
		{
			var bitmap:Bitmap = new Bitmap(_loadedFiles.get(id).bitmapData.clone());
			bitmap.smoothing = true;
			return bitmap;
		}
	}
	
	static public function getAtlasData(id:String):Dynamic
	{
		id += "_data";
		
		if (!_loadedFiles.exists(id))
		{
			trace("Data with the id: " + id + " not found.");
			return null;
		}
		else
		{
			var data:Dynamic = _loadedFiles.get(id);
			try
			{
				//var data:String = data.toString();
				return Json.parse(data);
			}
			catch (e:Error)
			{
				trace("JSON file with the id: " + id + " is not a valid JSON data.");
				return null;
			}
		}
	}
	
	//static public function getJson(id:String):Dynamic
	//{
		//if (GEngine.isEmbedded)
		//{
			//if(_embeddedFiles.exists(id))
			//{
				//try
				//{
					//return Json.parse(_embeddedFiles.get(id));
				//}
				//catch (e:Error)
				//{
					//trace(e.message);
				//}
			//}
			//else
			//{
				//throw "Data id: " + id + " not found";
			//}
			//
			//return null;
		//}
		//else
		//{
			//if(_loadedFiles.exists(id))
			//{
				//var data:Dynamic = _loadedFiles.get(id);
				//
				//try
				//{
					//var data:String = data.toString();
					//return Json.parse(data);
				//}
				//catch (e:Error)
				//{
					//trace("La codificación JSON no está en UTF8");
				//}
			//}
			//else
			//{
				//throw "Data id: " + id + " not found";
			//}
			//
			//return null;
		//}
	//}
	
	//static public function getText(id:String):Dynamic
	//{
		//if (GEngine.isEmbedded)
		//{
			//if(_embeddedFiles.exists(id))
			//{
				//return Std.string(_embeddedFiles.get(id));
			//}
			//else
			//{
				//throw "Data id: " + id + " not found";
			//}
			//
			//return null;
		//}
		//else
		//{
			//if(_loadedFiles.exists(id))
			//{
				//var data:Dynamic = _loadedFiles.get(id);
				//
				//try
				//{
					//var data:String = data.toString();
					//return data;
				//}
				//catch (e:Error)
				//{
					//trace("La codificación JSON no está en UTF8");
				//}
			//}
			//else
			//{
				//throw "Data id: " + id + " not found";
			//}
			//
			//return null;
		//}
	//}
}