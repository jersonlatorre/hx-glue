package glue.assets;

import glue.assets.AssetTypes.ButtonData;
import glue.assets.AssetTypes.ButtonFrame;
import glue.assets.AssetTypes.SpritesheetData;
import glue.assets.AssetValidator;
import glue.errors.AssetException;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import Xml;

@:final class Loader
{
	static inline var SUFFIX_IMAGE:String = "__image";
	static inline var SUFFIX_JSON:String = "__json";

	static final manifest = new AssetManifest();
	static final cache = new AssetCache();
	static final pipeline = new AssetPipeline(cache);

	static var completion:()->Void;
	static var requestedIds:Array<String> = [];
	static var isTracking:Bool = false;

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
				throw new AssetException(UnsupportedType, other);
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
		cleanupUnusedAssets();

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
		if (isTracking && requestedIds.indexOf(id) == -1)
		{
			requestedIds.push(id);
		}

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
			if (raw == null) throw new AssetException(NotLoaded, assetId, "Image");
			var bitmap:Bitmap = cast raw;
			cached = bitmap.bitmapData.clone();
			cache.storePrepared(assetId, cached);
		}
		return cached;
	}

	static public function getSpritesheet(assetId:String):SpritesheetData
	{
		ensureLoaded(assetId, "Spritesheet");
		var cached:SpritesheetData = cache.getPrepared(assetId);
		if (cached == null)
		{
			var metadataRaw:Any = cache.getRaw(assetId + SUFFIX_JSON);
			var imageRaw:Any = cache.getRaw(assetId + SUFFIX_IMAGE);
			if (metadataRaw == null || imageRaw == null)
			{
				throw new AssetException(NotLoaded, assetId, "Spritesheet");
			}

			var rawParsed:Any;
			try
			{
				rawParsed = Json.parse(preventUtf8(metadataRaw));
			}
			catch (e:Any)
			{
				throw new AssetException(InvalidFormat, assetId, "Invalid JSON in spritesheet");
			}

			var validated:ButtonData = AssetValidator.validateButtonData(rawParsed, assetId);
			var framesObj:Array<ButtonFrame> = validated.frames;

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

	/**
	 * Gets parsed JSON data with type safety via generic parameter
	 * @param assetId The asset identifier
	 * @return Parsed JSON cast to type T
	 */
	static public function getJsonAs<T>(assetId:String):T
	{
		ensureLoaded(assetId, "Json");
		var cached:Any = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw:Any = cache.getRaw(assetId);
			if (raw == null) throw new AssetException(NotLoaded, assetId, "Json");
			try
			{
				cached = Json.parse(preventUtf8(raw));
				cache.storePrepared(assetId, cached);
			}
			catch (e:Any)
			{
				throw new AssetException(InvalidFormat, assetId, "Invalid JSON syntax");
			}
		}
		return cached;
	}

	/**
	 * Gets button data from JSON with validation
	 */
	static public function getButtonData(assetId:String):ButtonData
	{
		var raw:Any = getJsonAs(assetId);
		return AssetValidator.validateButtonData(raw, assetId);
	}

	/**
	 * Gets parsed JSON data (untyped for backwards compatibility)
	 * @deprecated Use getJsonAs<T> for type safety
	 */
	static public function getJson(assetId:String):Any
	{
		return getJsonAs(assetId);
	}

	static public function getSound(assetId:String):Sound
	{
		ensureLoaded(assetId, "Sound");
		var cached:Sound = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw:Sound = cache.getRaw(assetId);
			if (raw == null) throw new AssetException(NotLoaded, assetId, "Sound");
			cached = raw;
			cache.storePrepared(assetId, cached);
		}
		return cached;
	}

	static public function getXml(assetId:String):Xml
	{
		ensureLoaded(assetId, "Xml");
		var cached:Xml = cache.getPrepared(assetId);
		if (cached == null)
		{
			var raw:Any = cache.getRaw(assetId);
			if (raw == null) throw new AssetException(NotLoaded, assetId, "Xml");
			try
			{
				cached = Xml.parse(preventUtf8(raw));
				cache.storePrepared(assetId, cached);
			}
			catch (e:Any)
			{
				throw new AssetException(InvalidFormat, assetId, "Invalid XML syntax");
			}
		}
		return cached;
	}

	static function ensureLoaded(assetId:String, kind:String):Void
	{
		if (!cache.has(assetId))
		{
			throw new AssetException(NotQueued, assetId, kind);
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

	/**
	 * Begins tracking which assets are requested by a new scene.
	 * Called automatically by SceneManager before scene transitions.
	 */
	@:allow(glue.scene.SceneManager)
	static function beginTracking():Void
	{
		requestedIds = [];
		isTracking = true;
	}

	/**
	 * Cleans up assets not requested by the current scene.
	 * Automatically expands spritesheet sub-IDs (image/json suffixes).
	 * Called automatically before downloading new scene assets.
	 */
	static function cleanupUnusedAssets():Void
	{
		if (!isTracking) return;
		isTracking = false;

		var keepIds:Array<String> = [];
		for (id in requestedIds)
		{
			keepIds.push(id);
			var type = cache.getType(id);
			if (type != null)
			{
				switch (type)
				{
					case AssetType.AdobeAnimateSpritesheet(_):
					{
						keepIds.push(id + SUFFIX_IMAGE);
						keepIds.push(id + SUFFIX_JSON);
					}
					default:
				}
			}
		}

		cache.clearAll(keepIds);
		requestedIds = [];
	}

	/**
	 * Returns cache statistics for debugging/monitoring memory usage
	 */
	static public function getCacheStats():{types:Int, raw:Int, prepared:Int}
	{
		return cache.getStats();
	}
}
