package glue.assets;

final class AssetManifest
{
	final requests:Array<AssetRequest> = [];

	public function new() {}

	public function add(request:AssetRequest):Void
	{
		requests.push(request);
	}

	public function consume():Array<AssetRequest>
	{
		var items = requests.copy();
		requests.resize(0);
		return items;
	}

	public function isEmpty():Bool
	{
		return requests.length == 0;
	}
}
