package glue.data;

import glue.display.GImage;
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
	static public var isDownloading = false;
	
	static public function load(data:Dynamic):Void
	{
		switch (data.type)
		{
			case "image":
			{
				var loader:Loader = new Loader();
				_files.push( { type:data.type, id: data.id, url: data.src, loader:loader } );
				totalFiles += 1;
			}

			case "spritesheet", "button":
			{
				var loader1:Loader = new Loader();
				_files.push( { type: "image", id: data.id, url: data.src, loader:loader1 } );
				
				var loader2:URLLoader = new URLLoader();

				var i:Int = Std.string(data.src).lastIndexOf('.');
				var s:String = Std.string(data.src).substring(0, i);
				_files.push({ type: "data", id: data.id + "_data", url: s + ".json", loader:loader2 });

				totalFiles += 2;
			}

			case "data":
			{
				var loader:URLLoader = new URLLoader();
				_files.push( { type:data.type, id: data.id, url: data.src, loader:loader } );
				totalFiles += 1;
			}

			default:
			{
				throw "Type " + data.type + " is not allowed.";
			}
		}
	}
	
	@:allow(glue.ui.GScene, glue.Glue)
	static function startDownload(callback:Dynamic):Void
	{
		trace("Initialize loading...");
		isDownloading = true;
		_callback = callback;

		if (totalFiles == 0)
		{
			trace("Loading complete........");
			isDownloading = false;
			if (_callback != null) _callback();
			return;
		}

		for (file in _files)
		{
			if (_loadedFiles.exists(file.id)) continue;
			
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
			trace("--- downloaded: " + file.id);

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
				downloadedFiles = 0;
				totalFiles = 0;
				isDownloading = false;
				trace("Loading complete.");
				if (_callback != null) _callback();
			}
		}
	}
	
	static function onError(file:Dynamic)
	{
		return function(e:IOErrorEvent)
		{
			throw "Error Downloading " + file.id;
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
			throw "-- File " + id + " not found.";
			return null;
		}
		else
		{
			var bitmap:Bitmap = new Bitmap(_loadedFiles.get(id).bitmapData);
			bitmap.cacheAsBitmap = true;
			bitmap.smoothing = true;
			return bitmap;
		}
	}
	
	static public function getJson(id:String):Dynamic
	{
		if (!_loadedFiles.exists(id))
		{
			throw "Data with the id: " + id + " not found.";
		}
		else
		{
			var data:String = preventUtf8(_loadedFiles.get(id));

			try
			{
				return Json.parse(data);
			}
			catch (e:Any)
			{
				throw "JSON file with the id: " + id + " is not a valid JSON data.";
			}
		}
	}

	static function preventUtf8(utf8String:String):String
	{
		if (utf8String.charCodeAt(0) == 65533 || utf8String.charCodeAt(0) == 255)
			utf8String = utf8String.substring(2, utf8String.length - 1);
		var s:Array<String> = utf8String.split(String.fromCharCode(0));
		var str:String = s.join("");
		return str;
	}
}