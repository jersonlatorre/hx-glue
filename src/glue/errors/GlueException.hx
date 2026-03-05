package glue.errors;

/**
 * Base exception for all Glue framework errors.
 * Allows catching all framework errors with: catch (e:GlueException)
 */
class GlueException extends haxe.Exception
{
	public function new(message:String)
	{
		super(message);
	}
}
