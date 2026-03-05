package glue.errors;

enum LayerErrorKind
{
	AlreadyExists;
	NotFound;
}

/**
 * Exception for layer management errors.
 */
class LayerException extends GlueException
{
	public final kind:LayerErrorKind;
	public final layerName:String;

	public function new(kind:LayerErrorKind, layerName:String)
	{
		this.kind = kind;
		this.layerName = layerName;

		var msg = switch (kind)
		{
			case AlreadyExists: 'Layer "$layerName" already exists';
			case NotFound: 'Layer "$layerName" not found';
		};

		super(msg);
	}
}
