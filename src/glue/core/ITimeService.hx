package glue.core;

/**
 * Interface for time services.
 * Allows mocking time for testing or custom time scaling.
 */
interface ITimeService
{
	var deltaTime(get, never):Float;
	var elapsed(get, never):Float;
	var scale(get, set):Float;
}
