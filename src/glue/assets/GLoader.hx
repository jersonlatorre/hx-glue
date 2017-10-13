package glue.assets;

import haxe.Json;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.media.Sound;

/**
 * ...
 * @author Jerson La Torre
 */

typedef Asset =
{
	type: String,
	data: Dynamic,
	content: Dynamic
}

enum DataType {	IMAGE; JSON; XML; SOUND; }

@:final class GLoader
{
	static inline var SUFFIX_IMAGE:String = "__image";
	static inline var SUFFIX_JSON:String = "__json";

	static var _callback:Dynamic;
	static var _assets:Map<String, Asset> = new Map<String, Asset>();
	static var _toLoadFiles:Array<Dynamic> = new Array<Dynamic>();
	static var _totalLoadedFiles:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var _currentLoadedFiles:Map<String, Dynamic> = new Map<String, Dynamic>();

	static public var downloadedFiles = 0;
	static public var totalFiles = 0;
	static public var isDownloading = false;

	static public function load(data:Dynamic)
	{
		if (_assets.exists(data.id))
		{
			return;
		}
		
		switch (data.type)
		{
			case "image":
			{
				var loader:Loader = new Loader();
				_toLoadFiles.push({ type: DataType.IMAGE, id: data.id, url: data.url, loader:loader });
				
				_assets.set(data.id, { type: "image", data: null, content: null });
				
				totalFiles += 1;
			}
			
			case "adobe_animate_spritesheet":
			{
				var loader1:Loader = new Loader();
				_toLoadFiles.push({ type: DataType.IMAGE, id: data.id + SUFFIX_IMAGE, url: data.url, fps:data.fps, loader: loader1 });
				
				var loader2:URLLoader = new URLLoader();
				var url:String = Std.string(data.url).substring(0, Std.string(data.url).lastIndexOf('.'));
				_toLoadFiles.push({ type: DataType.JSON, id: data.id + SUFFIX_JSON, url: url + ".json", loader: loader2 });

				_assets.set(data.id, { type: "adobe_animate_spritesheet", data: { }, content: null });
				_assets.set(data.id + SUFFIX_IMAGE, { type: "image", data: { }, content: null });
				_assets.set(data.id + SUFFIX_JSON, { type: "json", data: { }, content: null });

				totalFiles += 2;
			}
			
			case "sound":
			{
				if (data.group == null) data.group = "default";
				var loader:Sound = new Sound();
				_toLoadFiles.push({ type: DataType.SOUND, id: data.id, url: data.url, group: data.group, loader:loader });
				_assets.set(data.id, { type: "sound", data: null, content: null });
				totalFiles += 1;
			}
			
			case "json":
			{
				var loader:URLLoader = new URLLoader();
				_toLoadFiles.push({ type: DataType.JSON, id: data.id, url: data.url, loader: loader });
				
				_assets.set(data.id, { type: "json", data: { }, content: null });
				
				totalFiles += 1;
			}
		}
	}
	
	@:allow(glue.scene.GScene, glue.Glue, glue.scene.GSceneManager.showLoaderScene)
	static function startDownload(callback:Dynamic = null)
	{
		_callback = callback;

		if (totalFiles == 0)
		{
			isDownloading = false;
			if (_callback != null) _callback();
		}
		else
		{
			isDownloading = true;

			for (file in _toLoadFiles)
			{
				switch (file.type)
				{
					case DataType.IMAGE:
					{
						file.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDownloadFileComplete(file));
						file.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError(file));
					}
					
					case DataType.SOUND, DataType.JSON:
					{
						file.loader.addEventListener(Event.COMPLETE, onDownloadFileComplete(file));
						file.loader.addEventListener(IOErrorEvent.IO_ERROR, onError(file));
					}
					
					case DataType.XML:
					{
						
					}
				}
				
				file.loader.load(new URLRequest(file.url));
			}
		}
	}

	static function onDownloadFileComplete(file:Dynamic)
	{
		return function(e:Event)
		{
			if (Glue.isDebug) haxe.Log.trace('-- ${ file.id } ✔', null);

			switch (file.type)
			{
				case DataType.IMAGE:
				{
					_currentLoadedFiles.set(file.id, file.loader.content);
					file.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDownloadFileComplete(file));
				}
				
				case DataType.JSON, DataType.XML:
				{
					_currentLoadedFiles.set(file.id, preventUtf8(file.loader.data));
					file.loader.removeEventListener(Event.COMPLETE, onDownloadFileComplete(file));
				}
				
				case DataType.SOUND:
				{
					GSound.addSound(file.id, file.loader, file.group);
					_currentLoadedFiles.set(file.id, file.loader);
					file.loader.removeEventListener(Event.COMPLETE, onDownloadFileComplete(file));
				}
			}
			
			downloadedFiles++;
			
			if (downloadedFiles == totalFiles)
			{
				downloadedFiles = 0;
				totalFiles = 0;
				isDownloading = false;
				updateLoadedFiles();
				if (_callback != null) _callback();
			}
		}
	}

	static function updateLoadedFiles()
	{

		for (key in _currentLoadedFiles.keys())
		{
			_totalLoadedFiles.set(key, _currentLoadedFiles.get(key));
		}

		_toLoadFiles = new Array<Dynamic>();

		_currentLoadedFiles = new Map<String, Dynamic>();
	}
	
	static function onError(file:Dynamic)
	{
		return function(e:IOErrorEvent)
		{
			throw '\'${ file.url }\' not found.';
		}
	}

	static function onLoadComplete()
	{
		_callback();
	}
	
	static public function getImage(assetId:String):BitmapData
	{
		if (!_assets.exists(assetId)) throw 'Image \'${ assetId }\' was not loaded.';
		
		if (_assets.get(assetId).content == null)
		{
			if (!_totalLoadedFiles.exists(assetId)) throw 'Image \'${ assetId }\' was not loaded.';
			
			_assets.get(assetId).content = _totalLoadedFiles.get(assetId).bitmapData.clone();
		}
		
		return _assets.get(assetId).content;
	}
	
	static public function getSpritesheet(assetId:String):Dynamic
	{
		if (!_assets.exists(assetId)) throw 'Spritesheet \'${ assetId }\' was not loaded.';

		if (_assets.get(assetId).content == null)
		{
			switch (_assets.get(assetId).type)
			{
				case "adobe_animate_spritesheet":
				{
					var width:Int = 0;
					var height:Int = 0;
					var numFrames:Int = 0;
					var framesObj:Array<Dynamic> = Json.parse(_totalLoadedFiles.get(assetId + SUFFIX_JSON)).frames;
					var spritesheet:BitmapData = _totalLoadedFiles.get(assetId + SUFFIX_IMAGE).bitmapData.clone();

					width = framesObj[0].sourceSize.w;
					height = framesObj[0].sourceSize.h;
					numFrames = framesObj.length;

					// #if CACHE_FRAME_PER_FRAME
					// var frames:Array<BitmapData> = new Array<BitmapData>();

					// for (frame in framesObj)
					// {
					// 	var bitmapData = new BitmapData(width, height);
					// 	bitmapData.copyPixels(spritesheet, new Rectangle(frame.frame.x, frame.frame.y, width, height), new Point(0, 0));
					// 	frames.push(bitmapData);
					// }
					// #end

					// #if CREATE_ONE_ROW_SPRITESHEET
					var frames = new BitmapData(width * numFrames, height, true, 0x00000000);
					var i:Int = 0;
					for (frame in framesObj)
					{
						frames.copyPixels(spritesheet, new Rectangle(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h), new Point(width * i, 0));
						i++;
					}
					// #end

					_assets.get(assetId).content = { frames: frames, width: width, height: height, numFrames: numFrames };
				}
			}
		}

		return _assets.get(assetId).content;
	}
	
	static public function getJson(assetId:String):Dynamic
	{
		if (!_assets.exists(assetId)) throw 'Json \'${ assetId }\' was not loaded.';
		
		if (_assets.get(assetId).content == null)
		{
			if (!_totalLoadedFiles.exists(assetId)) throw 'Json \'${ assetId }\' was not loaded.';
			
			try
			{
				var data:String = preventUtf8(_totalLoadedFiles.get(assetId));
				_assets.get(assetId).content = Json.parse(data);
			}
			catch (e:Any)
			{
				throw '\'$assetId\' is not a valid Json file.';
			}
		}

		return _assets.get(assetId).content;
	}
	
	static public function getSound(assetId:String):Sound
	{
		if (!_assets.exists(assetId)) throw 'Sound \'${ assetId }\' was not loaded.';

		if (_assets.get(assetId).content == null)
		{
			if (!_totalLoadedFiles.exists(assetId)) throw 'Sound \'${ assetId }\' was not loaded.';

			try
			{
				_assets.get(assetId).content = _totalLoadedFiles.get(assetId);
			}
			catch (e:Any)
			{
				throw '\'$assetId\' is not a valid sound file.';
			}
		}
		
		return _assets.get(assetId).content;
	}
	
	static public function getXml(assetId:String):Dynamic
	{
		if (!_assets.exists(assetId)) throw 'Xml \'${ assetId }\' was not loaded.';

		if (_assets.get(assetId).content == null)
		{
			if (!_totalLoadedFiles.exists(assetId)) throw 'Xml \'${ assetId }\' was not loaded.';

			try
			{
				var data:String = preventUtf8(_totalLoadedFiles.get(assetId));
				_assets.get(assetId).content = Xml.parse(data);
			}
			catch (e:Any)
			{
				throw '\'$assetId\' is not a valid Xml file.';
			}
		}
		
		return _assets.get(assetId).content;
	}

	static function preventUtf8(utf8String:String):String
	{
		var str:String = utf8String;

		if (utf8String.charCodeAt(0) == 239)
		{
			str = utf8String.substring(3, utf8String.length - 1);
		}

		if (utf8String.charCodeAt(0) == 65533 || utf8String.charCodeAt(0) == 255)
		{
			utf8String = utf8String.substring(2, utf8String.length - 1);
			var s:Array<String> = utf8String.split(String.fromCharCode(0));
			str = s.join("");
		}
		
		return str;
	}
}