package glue.errors;

enum DisplayErrorKind
{
	AnimationNotFound;
	InvalidFrameCount;
	EmptySpritesheet;
	InvalidFontData;
}

/**
 * Exception for display/rendering errors (sprites, animations, fonts).
 */
class DisplayException extends GlueException
{
	public final kind:DisplayErrorKind;

	public function new(kind:DisplayErrorKind, details:String)
	{
		this.kind = kind;

		var msg = switch (kind)
		{
			case AnimationNotFound: 'Animation not found: $details';
			case InvalidFrameCount: 'Invalid frame count: $details';
			case EmptySpritesheet: 'Spritesheet has no frames: $details';
			case InvalidFontData: 'Invalid font data: $details';
		};

		super(msg);
	}
}
