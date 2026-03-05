package glue.tilemap;

import glue.assets.Loader;
import glue.display.Entity;
import glue.math.Vector2D;
import openfl.display.BitmapData;
import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

/**
 * Tilemap renderer with support for multiple layers.
 * Compatible with Tiled JSON export format.
 *
 * Usage:
 *   // Load tilemap JSON and tileset image
 *   Glue.load.json("level1", "assets/level1.json");
 *   Glue.load.image("tiles", "assets/tileset.png");
 *
 *   // In scene init:
 *   var map = new Tilemap("level1", "tiles", 16, 16);
 *   add(map);
 *
 *   // Check collisions:
 *   if (map.isSolidAt(player.position.x, player.position.y)) { ... }
 */
class Tilemap extends Entity
{
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var mapWidth:Int;
	public var mapHeight:Int;

	var layers:Array<TileLayer> = [];
	var tileset:Tileset;
	var tilemaps:Array<openfl.display.Tilemap> = [];
	var collisionLayer:TileLayer;

	/**
	 * Create a tilemap from Tiled JSON data
	 * @param jsonAssetId ID of the loaded JSON asset
	 * @param tilesetAssetId ID of the loaded tileset image
	 * @param tileWidth Width of each tile in pixels
	 * @param tileHeight Height of each tile in pixels
	 */
	public function new(jsonAssetId:String, tilesetAssetId:String, tileWidth:Int, tileHeight:Int)
	{
		super();

		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;

		var bitmapData:BitmapData = Loader.getImage(tilesetAssetId);
		tileset = createTileset(bitmapData, tileWidth, tileHeight);

		var jsonData:Dynamic = Loader.getJson(jsonAssetId);
		parseMapData(jsonData);

		renderLayers();
	}

	function createTileset(bitmapData:BitmapData, tw:Int, th:Int):Tileset
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

	function parseMapData(data:Dynamic):Void
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

				// Auto-detect collision layer
				var name = layerData.name.toLowerCase();
				if (name.indexOf("collision") != -1 || name.indexOf("solid") != -1)
				{
					collisionLayer = layer;
				}
			}
		}
	}

	function renderLayers():Void
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
						var tile = new Tile(tileId - 1, x * tileWidth, y * tileHeight);
						tilemap.addTile(tile);
					}
				}
			}

			tilemaps.push(tilemap);
			_skin.addChild(tilemap);
		}
	}

	/**
	 * Get layer by name
	 */
	public function getLayer(name:String):Null<TileLayer>
	{
		for (layer in layers)
		{
			if (layer.name == name) return layer;
		}
		return null;
	}

	/**
	 * Set the collision layer by name
	 */
	public function setCollisionLayer(name:String):Void
	{
		collisionLayer = getLayer(name);
	}

	/**
	 * Check if a world position is solid (collides with collision layer)
	 */
	public function isSolidAt(worldX:Float, worldY:Float):Bool
	{
		if (collisionLayer == null) return false;

		var tileX = worldToTileX(worldX);
		var tileY = worldToTileY(worldY);

		return collisionLayer.isSolid(tileX, tileY);
	}

	/**
	 * Check if a rectangle overlaps any solid tiles
	 */
	public function isSolidRect(x:Float, y:Float, w:Float, h:Float):Bool
	{
		if (collisionLayer == null) return false;

		var startX = worldToTileX(x);
		var startY = worldToTileY(y);
		var endX = worldToTileX(x + w);
		var endY = worldToTileY(y + h);

		for (ty in startY...endY + 1)
		{
			for (tx in startX...endX + 1)
			{
				if (collisionLayer.isSolid(tx, ty)) return true;
			}
		}

		return false;
	}

	/**
	 * Get tile ID at world position from collision layer
	 */
	public function getTileAt(worldX:Float, worldY:Float, ?layerName:String):Int
	{
		var layer = layerName != null ? getLayer(layerName) : collisionLayer;
		if (layer == null) return 0;

		var tileX = worldToTileX(worldX);
		var tileY = worldToTileY(worldY);

		return layer.getTile(tileX, tileY);
	}

	/**
	 * Convert world X to tile X
	 */
	public inline function worldToTileX(worldX:Float):Int
	{
		return Std.int((worldX - position.x) / tileWidth);
	}

	/**
	 * Convert world Y to tile Y
	 */
	public inline function worldToTileY(worldY:Float):Int
	{
		return Std.int((worldY - position.y) / tileHeight);
	}

	/**
	 * Convert tile X to world X (top-left corner)
	 */
	public inline function tileToWorldX(tileX:Int):Float
	{
		return position.x + tileX * tileWidth;
	}

	/**
	 * Convert tile Y to world Y (top-left corner)
	 */
	public inline function tileToWorldY(tileY:Int):Float
	{
		return position.y + tileY * tileHeight;
	}

	/**
	 * Get all tiles an entity overlaps with
	 */
	public function getOverlappingTiles(entity:Entity):Array<{x:Int, y:Int, id:Int}>
	{
		var result:Array<{x:Int, y:Int, id:Int}> = [];
		if (collisionLayer == null) return result;

		var startX = worldToTileX(entity.position.x + entity.bounds.x);
		var startY = worldToTileY(entity.position.y + entity.bounds.y);
		var endX = worldToTileX(entity.position.x + entity.bounds.x + entity.bounds.width);
		var endY = worldToTileY(entity.position.y + entity.bounds.y + entity.bounds.height);

		for (ty in startY...endY + 1)
		{
			for (tx in startX...endX + 1)
			{
				var id = collisionLayer.getTile(tx, ty);
				if (id > 0)
				{
					result.push({ x: tx, y: ty, id: id });
				}
			}
		}

		return result;
	}

	/**
	 * Resolve collision between entity and tilemap
	 * Returns the corrected position
	 */
	public function resolveCollision(entity:Entity):Vector2D
	{
		if (collisionLayer == null) return entity.position;

		var pos = new Vector2D(entity.position.x, entity.position.y);
		var bx = entity.bounds.x;
		var by = entity.bounds.y;
		var bw = entity.bounds.width;
		var bh = entity.bounds.height;

		// Check horizontal collision
		if (entity.velocity.x != 0)
		{
			var testX = pos.x + bx + (entity.velocity.x > 0 ? bw : 0);
			var startY = worldToTileY(pos.y + by + 1);
			var endY = worldToTileY(pos.y + by + bh - 1);

			for (ty in startY...endY + 1)
			{
				var tx = worldToTileX(testX);
				if (collisionLayer.isSolid(tx, ty))
				{
					if (entity.velocity.x > 0)
					{
						pos.x = tileToWorldX(tx) - bw - bx;
					}
					else
					{
						pos.x = tileToWorldX(tx + 1) - bx;
					}
					entity.velocity.x = 0;
					break;
				}
			}
		}

		// Check vertical collision
		if (entity.velocity.y != 0)
		{
			var testY = pos.y + by + (entity.velocity.y > 0 ? bh : 0);
			var startX = worldToTileX(pos.x + bx + 1);
			var endX = worldToTileX(pos.x + bx + bw - 1);

			for (tx in startX...endX + 1)
			{
				var ty = worldToTileY(testY);
				if (collisionLayer.isSolid(tx, ty))
				{
					if (entity.velocity.y > 0)
					{
						pos.y = tileToWorldY(ty) - bh - by;
					}
					else
					{
						pos.y = tileToWorldY(ty + 1) - by;
					}
					entity.velocity.y = 0;
					break;
				}
			}
		}

		return pos;
	}

	override public function destroy():Void
	{
		for (tilemap in tilemaps)
		{
			if (_skin.contains(tilemap))
			{
				_skin.removeChild(tilemap);
			}
		}
		tilemaps = [];
		layers = [];
		collisionLayer = null;

		super.destroy();
	}
}
