package glue.tilemap;

/**
 * A single layer in a tilemap
 */
class TileLayer
{
	public var name:String;
	public var width:Int;
	public var height:Int;
	public var data:Array<Int>;
	public var visible:Bool = true;
	public var opacity:Float = 1.0;

	public function new(name:String, width:Int, height:Int)
	{
		this.name = name;
		this.width = width;
		this.height = height;
		this.data = [];
	}

	/**
	 * Get tile ID at grid position
	 */
	public function getTile(x:Int, y:Int):Int
	{
		if (x < 0 || x >= width || y < 0 || y >= height) return 0;
		var index = y * width + x;
		if (index < 0 || index >= data.length) return 0;
		return data[index];
	}

	/**
	 * Set tile ID at grid position
	 */
	public function setTile(x:Int, y:Int, tileId:Int):Void
	{
		if (x < 0 || x >= width || y < 0 || y >= height) return;
		var index = y * width + x;
		if (index >= 0 && index < data.length)
		{
			data[index] = tileId;
		}
	}

	/**
	 * Check if tile is solid (non-zero)
	 */
	public function isSolid(x:Int, y:Int):Bool
	{
		return getTile(x, y) > 0;
	}
}
