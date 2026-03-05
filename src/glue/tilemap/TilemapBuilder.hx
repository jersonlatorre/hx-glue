package glue.tilemap;

import glue.assets.Loader;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

/**
 * Builder for creating tilemaps programmatically.
 *
 * Usage:
 *   var map = new TilemapBuilder("tiles", 16, 16)
 *       .setSize(20, 15)
 *       .addLayer("background")
 *       .fill(0, 0, 20, 15, 1)
 *       .addLayer("collision")
 *       .fillBorder(2)
 *       .build();
 */
class TilemapBuilder
{
	var tilesetAssetId:String;
	var tileWidth:Int;
	var tileHeight:Int;
	var mapWidth:Int = 10;
	var mapHeight:Int = 10;
	var layers:Array<TileLayer> = [];
	var currentLayer:TileLayer;
	var collisionLayerName:String;

	public function new(tilesetAssetId:String, tileWidth:Int, tileHeight:Int)
	{
		this.tilesetAssetId = tilesetAssetId;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
	}

	/**
	 * Set map size in tiles
	 */
	public function setSize(width:Int, height:Int):TilemapBuilder
	{
		mapWidth = width;
		mapHeight = height;
		return this;
	}

	/**
	 * Add a new layer
	 */
	public function addLayer(name:String):TilemapBuilder
	{
		currentLayer = new TileLayer(name, mapWidth, mapHeight);
		currentLayer.data = [for (i in 0...mapWidth * mapHeight) 0];
		layers.push(currentLayer);
		return this;
	}

	/**
	 * Set this layer as the collision layer
	 */
	public function asCollisionLayer():TilemapBuilder
	{
		if (currentLayer != null)
		{
			collisionLayerName = currentLayer.name;
		}
		return this;
	}

	/**
	 * Fill a rectangle with a tile ID
	 */
	public function fill(x:Int, y:Int, w:Int, h:Int, tileId:Int):TilemapBuilder
	{
		if (currentLayer == null) return this;

		for (ty in y...y + h)
		{
			for (tx in x...x + w)
			{
				currentLayer.setTile(tx, ty, tileId);
			}
		}
		return this;
	}

	/**
	 * Set a single tile
	 */
	public function setTile(x:Int, y:Int, tileId:Int):TilemapBuilder
	{
		if (currentLayer != null)
		{
			currentLayer.setTile(x, y, tileId);
		}
		return this;
	}

	/**
	 * Fill the border of the map
	 */
	public function fillBorder(tileId:Int):TilemapBuilder
	{
		if (currentLayer == null) return this;

		// Top and bottom
		for (x in 0...mapWidth)
		{
			currentLayer.setTile(x, 0, tileId);
			currentLayer.setTile(x, mapHeight - 1, tileId);
		}

		// Left and right
		for (y in 0...mapHeight)
		{
			currentLayer.setTile(0, y, tileId);
			currentLayer.setTile(mapWidth - 1, y, tileId);
		}

		return this;
	}

	/**
	 * Fill from an array of tile IDs (row by row)
	 */
	public function fillFromArray(data:Array<Int>):TilemapBuilder
	{
		if (currentLayer == null) return this;
		currentLayer.data = data.copy();
		return this;
	}

	/**
	 * Fill from a string map (each character maps to a tile ID)
	 */
	public function fillFromString(mapString:String, charMap:Map<String, Int>):TilemapBuilder
	{
		if (currentLayer == null) return this;

		var lines = mapString.split("\n");
		var y = 0;

		for (line in lines)
		{
			if (y >= mapHeight) break;
			var x = 0;

			for (i in 0...line.length)
			{
				if (x >= mapWidth) break;
				var char = line.charAt(i);
				var tileId = charMap.exists(char) ? charMap.get(char) : 0;
				currentLayer.setTile(x, y, tileId);
				x++;
			}
			y++;
		}

		return this;
	}

	/**
	 * Build the final tilemap
	 */
	public function build():Tilemap
	{
		var jsonData:Dynamic = {
			width: mapWidth,
			height: mapHeight,
			tilewidth: tileWidth,
			tileheight: tileHeight,
			layers: []
		};

		for (layer in layers)
		{
			jsonData.layers.push({
				type: "tilelayer",
				name: layer.name,
				width: layer.width,
				height: layer.height,
				data: layer.data,
				visible: layer.visible,
				opacity: layer.opacity
			});
		}

		// Create a temporary tilemap using the built data
		var tilemap = new ProgrammaticTilemap(jsonData, tilesetAssetId, tileWidth, tileHeight);

		if (collisionLayerName != null)
		{
			tilemap.setCollisionLayer(collisionLayerName);
		}

		return tilemap;
	}
}

/**
 * Tilemap that can be created from in-memory data
 */
private class ProgrammaticTilemap extends Tilemap
{
	public function new(jsonData:Dynamic, tilesetAssetId:String, tileWidth:Int, tileHeight:Int)
	{
		// Skip parent constructor's JSON loading
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;

		var bitmapData:BitmapData = Loader.getImage(tilesetAssetId);
		tileset = createTilesetInternal(bitmapData, tileWidth, tileHeight);

		parseMapDataInternal(jsonData);
		renderLayersInternal();
	}

	function createTilesetInternal(bitmapData:BitmapData, tw:Int, th:Int):Tileset
	{
		var ts = new Tileset(bitmapData);
		var cols = Std.int(bitmapData.width / tw);
		var rows = Std.int(bitmapData.height / th);

		for (y in 0...rows)
		{
			for (x in 0...cols)
			{
				ts.addRect(new Rectangle(x * tw, y * th, tw, th));
			}
		}

		return ts;
	}

	function parseMapDataInternal(data:Dynamic):Void
	{
		mapWidth = data.width;
		mapHeight = data.height;

		if (data.tilewidth != null) tileWidth = data.tilewidth;
		if (data.tileheight != null) tileHeight = data.tileheight;

		width = mapWidth * tileWidth;
		height = mapHeight * tileHeight;

		var layersData:Array<Dynamic> = data.layers;
		if (layersData == null) return;

		for (layerData in layersData)
		{
			if (layerData.type == "tilelayer")
			{
				var layer = new TileLayer(layerData.name, layerData.width, layerData.height);
				layer.visible = layerData.visible != false;
				layer.opacity = layerData.opacity != null ? layerData.opacity : 1.0;

				var tileData:Array<Int> = layerData.data;
				if (tileData != null)
				{
					layer.data = tileData.copy();
				}

				layers.push(layer);
			}
		}
	}

	function renderLayersInternal():Void
	{
		for (layer in layers)
		{
			if (!layer.visible) continue;

			var tilemap = new openfl.display.Tilemap(
				mapWidth * tileWidth,
				mapHeight * tileHeight,
				tileset
			);
			tilemap.alpha = layer.opacity;

			for (y in 0...layer.height)
			{
				for (x in 0...layer.width)
				{
					var tileId = layer.data[y * layer.width + x];
					if (tileId > 0)
					{
						var tile = new openfl.display.Tile(tileId - 1, x * tileWidth, y * tileHeight);
						tilemap.addTile(tile);
					}
				}
			}

			tilemaps.push(tilemap);
			_skin.addChild(tilemap);
		}
	}
}
