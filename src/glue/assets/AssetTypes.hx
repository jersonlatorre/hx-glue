package glue.assets;

import openfl.display.Tileset;

/**
 * Type-safe data structures for loaded assets
 * Replaces Dynamic usage for better compile-time safety
 */

/**
 * Data for a loaded spritesheet (Adobe Animate format)
 */
typedef SpritesheetData = {
	var tileset:Tileset;
	var frameIds:Array<Int>;
	var width:Int;
	var height:Int;
}

/**
 * Frame data from Adobe Animate JSON export
 */
typedef FrameInfo = {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}

/**
 * Source size from Adobe Animate JSON export
 */
typedef SourceSize = {
	var w:Int;
	var h:Int;
}

/**
 * Single frame data for buttons and spritesheets
 */
typedef ButtonFrame = {
	var frame:FrameInfo;
	var sourceSize:SourceSize;
}

/**
 * Complete button data from JSON
 */
typedef ButtonData = {
	var frames:Array<ButtonFrame>;
}
