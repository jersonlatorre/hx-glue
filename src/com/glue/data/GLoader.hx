package com.glue.data;

import com.glue.ui.GScene;
import com.glue.ui.GSceneManager;
import com.glue.display.GImage;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author Jerson La Torre
 */

@final class GLoader
{
	static var _callback:Dynamic;
	static var _files:Array<Dynamic> = new Array<Dynamic>();
	static var _loadedFiles:Map<String, Dynamic> = new Map<String, Dynamic>();
	static public var downloadedFiles = 0;
	static public var totalFiles = 0;
	
	static public function queue(data:Dynamic):Void
	{
		switch (data.type)
		{
			case "image":
			{
				var loader:Loader = new Loader();
				_files.push( { type:data.type, id: data.id, url: data.src, loader:loader } );
				totalFiles += 1;
			}

			case "sprite":
			{
				var loader1:Loader = new Loader();
				_files.push( { type: "image", id: data.id, url: data.src + ".png", loader:loader1 } );
				
				var loader2:URLLoader = new URLLoader();
				_files.push( { type: "data", id: data.id + "_data", url: data.src + ".json", loader:loader2 } );

				totalFiles += 2;
			}

			case "data":
			{
				var loader:URLLoader = new URLLoader();
				_files.push( { type:data.type, id: data.id, url: data.src, loader:loader } );
				totalFiles += 1;
			}
		}
	}
	
	static public function load(callback:Dynamic):Void
	{
		_callback = callback;

		trace("--- Initialize loading.");

		for (file in _files)
		{
			if (file.type == "image")
			{
				file.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDownloadFileComplete(file));
				file.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError(file));
			}
			else
			{
				file.loader.addEventListener(Event.COMPLETE, onDownloadFileComplete(file));
				file.loader.addEventListener(IOErrorEvent.IO_ERROR, onError(file));
			}

			file.loader.load(new URLRequest(file.url));
		}
	}

	static function onDownloadFileComplete(file:Dynamic)
	{
		return function(e:Event)
		{
			trace("downloaded file: " + file.id);

			if (file.type == "image")
			{
				_loadedFiles.set(file.id, file.loader.content);
				file.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDownloadFileComplete);
				
				// preload images
				var _img = new GImage(file.id);
				_img.addToLayer(Glue.cacheCanvas);
			}
			else
			{
				_loadedFiles.set(file.id, file.loader.data);
				file.loader.removeEventListener(Event.COMPLETE, onDownloadFileComplete);
			}

			downloadedFiles++;
			
			if (downloadedFiles == totalFiles)
			{
				trace("--- Loading complete.");
				_callback();
			}
		}
	}
	
	static function onError(file:Dynamic)
	{
		return function(e:IOErrorEvent)
		{
			trace("Error Downloading " + file.id);
		}
	}

	static function onLoadComplete():Void 
	{
		_callback();
	}
	
	static public function getImage(id:String):Bitmap
	{
		if (!_loadedFiles.exists(id))
		{
			throw "--- File " + id + " not found.";
			return null;
		}
		else
		{
			// var bitmap:Bitmap = _loadedFiles.get(id);
			// var bitmap:Bitmap = new Bitmap(_loadedFiles.get(id).bitmapData.clone());
			var bitmap:Bitmap = new Bitmap(_loadedFiles.get(id).bitmapData);
			// bitmap.cacheAsBitmap = true;
			// bitmap.smoothing = true;
			return bitmap;
		}
	}
	
	static public function getJson(id:String):Dynamic
	{
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
				return Json.parse(data);
			}
			catch (e:Error)
			{
				trace("JSON file with the id: " + id + " is not a valid JSON data.");
				return null;
			}
		}
	}
	
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