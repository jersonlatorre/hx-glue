package glue.assets;

import glue.assets.AssetTypes.ButtonData;
import glue.assets.AssetTypes.ButtonFrame;
import glue.errors.AssetException;

/**
 * Validates asset data structures at load time.
 * Provides clear error messages when JSON format is incorrect.
 */
class AssetValidator
{
	/**
	 * Validates button/spritesheet JSON data.
	 * Throws AssetException with details if invalid.
	 */
	public static function validateButtonData(data:Any, assetId:String):ButtonData
	{
		if (data == null)
		{
			throw new AssetException(InvalidFormat, assetId, "JSON data is null");
		}

		var obj:Dynamic = data;

		if (obj.frames == null)
		{
			throw new AssetException(InvalidFormat, assetId, "Missing 'frames' array in JSON");
		}

		var frames:Array<Dynamic> = obj.frames;
		if (frames.length == 0)
		{
			throw new AssetException(InvalidFormat, assetId, "'frames' array is empty");
		}

		var validatedFrames:Array<ButtonFrame> = [];
		for (i in 0...frames.length)
		{
			var frame = frames[i];
			if (frame == null)
			{
				throw new AssetException(InvalidFormat, assetId, 'Frame $i is null');
			}

			if (frame.frame == null)
			{
				throw new AssetException(InvalidFormat, assetId, 'Frame $i missing "frame" object');
			}

			if (frame.sourceSize == null)
			{
				throw new AssetException(InvalidFormat, assetId, 'Frame $i missing "sourceSize" object');
			}

			var frameInfo = frame.frame;
			if (frameInfo.x == null || frameInfo.y == null || frameInfo.w == null || frameInfo.h == null)
			{
				throw new AssetException(InvalidFormat, assetId, 'Frame $i has incomplete "frame" data (needs x, y, w, h)');
			}

			var sourceSize = frame.sourceSize;
			if (sourceSize.w == null || sourceSize.h == null)
			{
				throw new AssetException(InvalidFormat, assetId, 'Frame $i has incomplete "sourceSize" data (needs w, h)');
			}

			validatedFrames.push({
				frame: { x: frameInfo.x, y: frameInfo.y, w: frameInfo.w, h: frameInfo.h },
				sourceSize: { w: sourceSize.w, h: sourceSize.h }
			});
		}

		return { frames: validatedFrames };
	}

	/**
	 * Validates that a value is not null.
	 */
	public static function requireNotNull(value:Any, assetId:String, fieldName:String):Void
	{
		if (value == null)
		{
			throw new AssetException(InvalidFormat, assetId, 'Missing required field: $fieldName');
		}
	}

	/**
	 * Validates that a value is an array with at least minLength elements.
	 */
	public static function requireArray(value:Any, assetId:String, fieldName:String, minLength:Int = 0):Void
	{
		if (value == null)
		{
			throw new AssetException(InvalidFormat, assetId, 'Missing required array: $fieldName');
		}

		var arr:Array<Dynamic> = value;
		if (arr.length < minLength)
		{
			throw new AssetException(InvalidFormat, assetId, '$fieldName must have at least $minLength elements');
		}
	}
}
