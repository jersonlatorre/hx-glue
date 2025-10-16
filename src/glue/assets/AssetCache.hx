package glue.assets;

final class AssetCache
{
	final types:Map<String, AssetType> = new Map();
	final raw:Map<String, Dynamic> = new Map();
	final prepared:Map<String, Dynamic> = new Map();

	public function new() {}

	public function define(id:String, type:AssetType):Void
	{
		types.set(id, type);
	}

	public function has(id:String):Bool
	{
		return types.exists(id);
	}

	public function getType(id:String):Null<AssetType>
	{
		return types.get(id);
	}

	public function storeRaw(id:String, data:Dynamic):Void
	{
		raw.set(id, data);
	}

	public function getRaw(id:String):Dynamic
	{
		return raw.get(id);
	}

	public function storePrepared(id:String, data:Dynamic):Void
	{
		prepared.set(id, data);
	}

	public function getPrepared(id:String):Dynamic
	{
		return prepared.get(id);
	}

	public function clearPrepared(id:String):Void
	{
		prepared.remove(id);
	}
}
