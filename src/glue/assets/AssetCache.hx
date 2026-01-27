package glue.assets;

/**
 * Asset cache with support for cleanup to prevent memory leaks
 * Stores both raw loaded data and prepared/processed assets
 */
final class AssetCache
{
	final types:Map<String, AssetType> = new Map();
	final raw:Map<String, Any> = new Map();
	final prepared:Map<String, Any> = new Map();

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

	public function storeRaw(id:String, data:Any):Void
	{
		raw.set(id, data);
	}

	public function getRaw(id:String):Any
	{
		return raw.get(id);
	}

	public function storePrepared(id:String, data:Any):Void
	{
		prepared.set(id, data);
	}

	public function getPrepared(id:String):Any
	{
		return prepared.get(id);
	}

	public function clearPrepared(id:String):Void
	{
		prepared.remove(id);
	}

	/**
	 * Clears a specific asset from all caches (raw, prepared, and type registry)
	 */
	public function clearAsset(id:String):Void
	{
		types.remove(id);
		raw.remove(id);
		prepared.remove(id);
	}

	/**
	 * Clears multiple assets by their IDs
	 */
	public function clearAssets(ids:Array<String>):Void
	{
		for (id in ids)
		{
			clearAsset(id);
		}
	}

	/**
	 * Clears all cached assets - use on scene transitions to free memory
	 * @param keepIds Optional array of asset IDs to preserve (e.g., global/shared assets)
	 */
	public function clearAll(?keepIds:Array<String>):Void
	{
		if (keepIds == null || keepIds.length == 0)
		{
			types.clear();
			raw.clear();
			prepared.clear();
		}
		else
		{
			var keepSet = new Map<String, Bool>();
			for (id in keepIds)
			{
				keepSet.set(id, true);
			}

			var toRemove:Array<String> = [];
			for (id in types.keys())
			{
				if (!keepSet.exists(id))
				{
					toRemove.push(id);
				}
			}

			for (id in toRemove)
			{
				clearAsset(id);
			}
		}
	}

	/**
	 * Clears only the prepared cache, keeping raw assets for reprocessing
	 */
	public function clearPreparedCache():Void
	{
		prepared.clear();
	}

	/**
	 * Returns the number of cached assets (for debugging/monitoring)
	 */
	public function getStats():{types:Int, raw:Int, prepared:Int}
	{
		var typeCount = 0;
		var rawCount = 0;
		var preparedCount = 0;

		for (_ in types) typeCount++;
		for (_ in raw) rawCount++;
		for (_ in prepared) preparedCount++;

		return { types: typeCount, raw: rawCount, prepared: preparedCount };
	}
}
