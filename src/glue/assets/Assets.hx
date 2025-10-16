package glue.assets;

import glue.assets.Loader;

/**
 * Simplified assets API with less verbosity
 * Provides shortcuts for common asset loading operations
 */
@:final class Assets
{
	public static inline function image(id:String, url:String):Void
	{
		Loader.load({ type: "image", id: id, url: url });
	}

	public static inline function json(id:String, url:String):Void
	{
		Loader.load({ type: "json", id: id, url: url });
	}

	public static inline function sound(id:String, url:String, ?group:String):Void
	{
		Loader.load({ type: "sound", id: id, url: url, group: group });
	}

	public static inline function spritesheet(id:String, url:String, fps:Int = 30):Void
	{
		Loader.load({ type: "adobe_animate_spritesheet", id: id, url: url, fps: fps });
	}

	public static function batch():AssetBatch
	{
		return new AssetBatch();
	}

	public static inline function getImage(id:String)
	{
		return Loader.getImage(id);
	}

	public static inline function getJson(id:String)
	{
		return Loader.getJson(id);
	}

	public static inline function getSound(id:String)
	{
		return Loader.getSound(id);
	}

	public static inline function getSpritesheet(id:String)
	{
		return Loader.getSpritesheet(id);
	}
}

/**
 * Fluent API for batch asset loading
 */
class AssetBatch
{
	public function new() {}

	public function image(id:String, url:String):AssetBatch
	{
		Assets.image(id, url);
		return this;
	}

	public function json(id:String, url:String):AssetBatch
	{
		Assets.json(id, url);
		return this;
	}

	public function sound(id:String, url:String, ?group:String):AssetBatch
	{
		Assets.sound(id, url, group);
		return this;
	}

	public function spritesheet(id:String, url:String, fps:Int = 30):AssetBatch
	{
		Assets.spritesheet(id, url, fps);
		return this;
	}

	public function fromPath(basePath:String):AssetPathBatch
	{
		return new AssetPathBatch(basePath);
	}
}

/**
 * Asset loading with base path support
 */
class AssetPathBatch
{
	final basePath:String;

	public function new(basePath:String)
	{
		this.basePath = basePath;
	}

	public function image(id:String, filename:String):AssetPathBatch
	{
		Assets.image(id, basePath + "/" + filename);
		return this;
	}

	public function json(id:String, filename:String):AssetPathBatch
	{
		Assets.json(id, basePath + "/" + filename);
		return this;
	}

	public function sound(id:String, filename:String, ?group:String):AssetPathBatch
	{
		Assets.sound(id, basePath + "/" + filename, group);
		return this;
	}

	public function spritesheet(id:String, filename:String, fps:Int = 30):AssetPathBatch
	{
		Assets.spritesheet(id, basePath + "/" + filename, fps);
		return this;
	}
}
