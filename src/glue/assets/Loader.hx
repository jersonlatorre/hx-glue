package glue.assets;

import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.display.Tileset;
import Xml;

@:final class Loader
{
	static inline var SUFFIX_IMAGE:String = "__image";
	static inline var SUFFIX_JSON:String = "__json";

	static final manifest = new AssetManifest();
	static final cache = new AssetCache();
	static final pipeline = new AssetPipeline(cache);

	static var completion:()->Void;

	static public var downloadedFiles(get, never):Int;
	static public var totalFiles(get, never):Int;
	static public var isDownloading(get, never):Bool;

	static function get_downloadedFiles():Int return pipeline.downloadedFiles;
	static function get_totalFiles():Int return pipeline.totalFiles;
	static function get_isDownloading():Bool return pipeline.isDownloading;

	static public function load(data:Dynamic):Void
	{
		var id:String = data.id;
		switch (data.type)
		{
			case "image":
			{
				queueInternal(id, data.url, AssetType.Image);
			}

			case "json":
			{
				queueInternal(id, data.url, AssetType.Json);
			}

			case "sound":
			{
				var group = data.group == null ? "default" : data.group;
				queueInternal(id, data.url, AssetType.Sound(group));
			}

			case "adobe_animate_spritesheet":
			{
				var fps:Int = data.fps == null ? 30 : data.fps;
				queueInternal(id, data.url, AssetType.AdobeAnimateSpritesheet(fps));
			}

			case other:
			{
				throw 'Unsupported asset type "' + other + '"';
			}
		}
	}

	static public function queue(request:AssetRequest):Void
	{
		queueInternal(request.id, request.url, request.type);
	}

	@:allow(glue.scene.Scene, glue.Glue, glue.scene.SceneManager.showLoaderScene)
	static function startDownload(callback:()->Void = null):Void
	{
		completion = callback;
		pipeline.process(manifest, function()
		{
			if (completion != null)
			{
				completion();
				completion = null;
			}
		});
	}

	static function enqueue(request:AssetRequest):Void
	{
		manifest.add(request);
	}

	static function queueInternal(id:String, url:String, type:AssetType):Void
	{
		if (cache.has(id)) return;
		cache.define(id, type);
		enqueue({ id: id, url: url, type: type });
	}

	static public function getImage(assetId:String):BitmapData
	{
		ensureLoaded(assetId, "Image");
		var cached:BitmapData = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw = cache.getRaw(assetId);
			if (raw == null) throw 'Image \'' + assetId + '\' was not loaded.';
			var bitmap:Bitmap = cast raw;
			cached = bitmap.bitmapData.clone();
			cache.storePrepared(assetId, cached);
		}
		return cached;
	}

	static public function getSpritesheet(assetId:String):Dynamic
	{
		ensureLoaded(assetId, "Spritesheet");
		var cached = cache.getPrepared(assetId);
		if (cached == null)
		{
			var metadataRaw = cache.getRaw(assetId + SUFFIX_JSON);
			var imageRaw = cache.getRaw(assetId + SUFFIX_IMAGE);
			if (metadataRaw == null || imageRaw == null)
			{
				throw 'Spritesheet \'' + assetId + '\' was not loaded.';
			}
	var framesObj:Array<Dynamic> = Json.parse(preventUtf8(metadataRaw)).frames;
	var spritesheetSource:Bitmap = cast imageRaw;
	var tileset = new Tileset(spritesheetSource.bitmapData);
	var frameIds:Array<Int> = [];
	for (frame in framesObj)
	{
		var rect = new Rectangle(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h);
		frameIds.push(tileset.addRect(rect));
	}
	var width = framesObj[0].sourceSize.w;
	var height = framesObj[0].sourceSize.h;
	cached = { tileset: tileset, frameIds: frameIds, width: width, height: height };
			cache.storePrepared(assetId, cached);
		}
		return cached;
	}

	static public function getJson(assetId:String):Dynamic
	{
		ensureLoaded(assetId, "Json");
		var cached = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw = cache.getRaw(assetId);
			if (raw == null) throw 'Json \'' + assetId + '\' was not loaded.';
			try
			{
				cached = Json.parse(preventUtf8(raw));
				cache.storePrepared(assetId, cached);
			}
			catch (e:Any)
			{
				throw '\'' + assetId + '\' is not a valid Json file.';
			}
		}
		return cached;
	}

	static public function getSound(assetId:String):Sound
	{
		ensureLoaded(assetId, "Sound");
		var cached:Sound = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw:Sound = cache.getRaw(assetId);
			if (raw == null) throw 'Sound \'' + assetId + '\' was not loaded.';
			cached = raw;
			cache.storePrepared(assetId, cached);
		}
		return cached;
	}

	static public function getXml(assetId:String):Dynamic
	{
		ensureLoaded(assetId, "Xml");
		var cached = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw = cache.getRaw(assetId);
			if (raw == null) throw 'Xml \'' + assetId + '\' was not loaded.';
			try
			{
				cached = Xml.parse(preventUtf8(raw));
				cache.storePrepared(assetId, cached);
			}
			catch (e:Any)
			{
				throw '\'' + assetId + '\' is not a valid Xml file.';
			}
		}
		return cached;
	}

	static function ensureLoaded(assetId:String, kind:String):Void
	{
		if (!cache.has(assetId))
		{
			throw kind + " '" + assetId + "' was not queued for loading.";
		}
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
