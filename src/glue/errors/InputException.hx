package glue.errors;

/**
 * Exception for input-related errors.
 */
class InputException extends GlueException
{
	public final action:String;

	public function new(action:String)
	{
		this.action = action;
		super('Input action "$action" is not bound to any key');
	}
}
