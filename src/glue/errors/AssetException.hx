package glue.errors;

enum AssetErrorKind
{
	NotLoaded;
	NotQueued;
	NotFound;
	InvalidFormat;
	UnsupportedType;
}

/**
 * Exception for asset loading and retrieval errors.
 *
 * Example:
 *   try {
 *       var img = Loader.getImage("player");
 *   } catch (e:AssetException) {
 *       switch (e.kind) {
 *           case NotLoaded: // handle
 *           case NotQueued: // handle
 *           default:
 *       }
 *   }
 */
class AssetException extends GlueException
{
	public final kind:AssetErrorKind;
	public final assetId:String;

	public function new(kind:AssetErrorKind, assetId:String, ?details:String)
	{
		this.kind = kind;
		this.assetId = assetId;

		var msg = switch (kind)
		{
			case NotLoaded: 'Asset "$assetId" was not loaded';
			case NotQueued: 'Asset "$assetId" was not queued for loading';
			case NotFound: 'Asset "$assetId" not found';
			case InvalidFormat: 'Asset "$assetId" has invalid format';
			case UnsupportedType: 'Unsupported asset type "$assetId"';
		};

		if (details != null)
		{
			msg += ': $details';
		}

		super(msg);
	}
}
