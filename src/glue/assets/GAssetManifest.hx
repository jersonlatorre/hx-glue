package glue.assets;

final class GAssetManifest
{
	final requests:Array<GAssetRequest> = [];

	public function new() {}

	public function add(request:GAssetRequest):Void
	{
		requests.push(request);
	}

	public function consume():Array<GAssetRequest>
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
