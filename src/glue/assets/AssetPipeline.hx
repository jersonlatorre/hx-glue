package glue.assets;

import glue.assets.Sound;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventType;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.media.Sound;

private enum DataType
{
	IMAGE;
	JSON;
	SOUND;
}

private typedef PendingFile =
{
	var id:String;
	var url:String;
	var type:DataType;
	var loader:Dynamic;
	@:optional var group:String;
	@:optional var fps:Int;
	@:optional var completeHandler:Event->Void;
	@:optional var errorHandler:Event->Void;
}

final class AssetPipeline
{
	static inline var SUFFIX_IMAGE:String = "__image";
	static inline var SUFFIX_JSON:String = "__json";
	static final IO_ERROR_EVENT:EventType<Event> = cast IOErrorEvent.IO_ERROR;

	public var downloadedFiles(default, null):Int = 0;
	public var totalFiles(default, null):Int = 0;
	public var isDownloading(default, null):Bool = false;

	final cache:AssetCache;
	var pending:Array<PendingFile> = [];
	var onComplete:Void->Void;

	public function new(cache:AssetCache)
	{
		this.cache = cache;
	}

	public function process(manifest:AssetManifest, onComplete:Void->Void):Void
	{
		if (isDownloading)
		{
			return;
		}

		var requests = manifest.consume();
		if (requests.length == 0)
		{
			if (onComplete != null)
			{
				onComplete();
			}
			return;
		}

		this.onComplete = onComplete;
		pending = [];
		for (request in requests)
		{
			switch (request.type)
			{
				case AssetType.Image:
				{
					cache.define(request.id, request.type);
					pending.push({ id: request.id, url: request.url, type: DataType.IMAGE, loader: new Loader() });
				}

				case AssetType.Json:
				{
					cache.define(request.id, request.type);
					pending.push({ id: request.id, url: request.url, type: DataType.JSON, loader: new URLLoader() });
				}

				case AssetType.Sound(group):
				{
					cache.define(request.id, request.type);
					pending.push({ id: request.id, url: request.url, type: DataType.SOUND, loader: new Sound(), group: group });
				}

				case AssetType.AdobeAnimateSpritesheet(fps):
				{
					cache.define(request.id, request.type);
					var imageId = request.id + SUFFIX_IMAGE;
					var jsonId = request.id + SUFFIX_JSON;

					cache.define(imageId, AssetType.Image);
					cache.define(jsonId, AssetType.Json);

					pending.push({ id: imageId, url: request.url, type: DataType.IMAGE, loader: new Loader(), fps: fps });

					var baseUrl = Std.string(request.url);
					var trimmed = baseUrl.substring(0, baseUrl.lastIndexOf('.'));
					pending.push({ id: jsonId, url: trimmed + ".json", type: DataType.JSON, loader: new URLLoader(), fps: fps });
				}
			}
		}

		totalFiles = pending.length;
		downloadedFiles = 0;
		isDownloading = totalFiles > 0;

		for (file in pending)
		{
			attachListeners(file);
			file.loader.load(new URLRequest(file.url));
		}
	}

	function attachListeners(file:PendingFile):Void
	{
		var completeHandler:Event->Void = function(e:Event) { handleComplete(file, e); };
		var errorHandler:Event->Void = function(e:Event) { handleError(file, cast e); };
		file.completeHandler = completeHandler;
		file.errorHandler = errorHandler;

		switch (file.type)
		{
			case DataType.IMAGE:
			{
				var info = file.loader.contentLoaderInfo;
				info.addEventListener(Event.COMPLETE, completeHandler);
				info.addEventListener(IO_ERROR_EVENT, errorHandler);
			}

			case DataType.JSON, DataType.SOUND:
			{
				var dispatcher:EventDispatcher = cast file.loader;
				dispatcher.addEventListener(Event.COMPLETE, completeHandler);
				dispatcher.addEventListener(IO_ERROR_EVENT, errorHandler);
			}
		}
	}

	function detachListeners(file:PendingFile):Void
	{
		switch (file.type)
		{
			case DataType.IMAGE:
			{
				var info = file.loader.contentLoaderInfo;
				info.removeEventListener(Event.COMPLETE, file.completeHandler);
				info.removeEventListener(IO_ERROR_EVENT, file.errorHandler);
			}

			case DataType.JSON, DataType.SOUND:
			{
				var dispatcher:EventDispatcher = cast file.loader;
				dispatcher.removeEventListener(Event.COMPLETE, file.completeHandler);
				dispatcher.removeEventListener(IO_ERROR_EVENT, file.errorHandler);
			}
		}

		file.completeHandler = null;
		file.errorHandler = null;
	}

	function handleComplete(file:PendingFile, _:Event):Void
	{
		detachListeners(file);

		switch (file.type)
		{
			case DataType.IMAGE:
			{
				cache.storeRaw(file.id, file.loader.content);
			}

			case DataType.JSON:
			{
				cache.storeRaw(file.id, file.loader.data);
			}

			case DataType.SOUND:
			{
				var group = file.group == null ? "default" : file.group;
				Sound.addSound(file.id, file.loader, group);
				cache.storeRaw(file.id, file.loader);
			}
		}

		downloadedFiles++;

		if (downloadedFiles == totalFiles)
		{
			finish();
		}
	}

	function handleError(file:PendingFile, error:IOErrorEvent):Void
	{
		detachListeners(file);
		throw '\'' + file.url + '\' not found.';
	}

	function finish():Void
	{
		isDownloading = false;
		pending = [];
		totalFiles = 0;
		downloadedFiles = 0;
		if (onComplete != null)
		{
			onComplete();
			onComplete = null;
		}
	}

	public function getImageSuffix():String
	{
		return SUFFIX_IMAGE;
	}

	public function getJsonSuffix():String
	{
		return SUFFIX_JSON;
	}
}
