package glue.math;

/**
 * Mathematical and common constants for Glue framework
 * Replaces magic numbers throughout the codebase
 * @author Jerson La Torre
 */

@:final class GConstants
{
	public static inline final RAD_TO_DEG:Float = 57.29578;
	public static inline final DEG_TO_RAD:Float = 0.0174533;

	public static inline final DEFAULT_FADE_DURATION:Float = 0.3;
	public static inline final DEFAULT_CAMERA_DELAY:Float = 0.1;

	public static inline final HALF:Float = 0.5;

	public static inline final COLOR_DEBUG_RED:Int = 0xFF0000;
	public static inline final COLOR_DEBUG_GREEN:Int = 0x00FF00;
	public static inline final COLOR_BLACK:Int = 0x000000;

	public static inline final ALPHA_OPAQUE:Float = 1.0;
	public static inline final ALPHA_TRANSPARENT:Float = 0.0;
	public static inline final ALPHA_DEBUG_OVERLAY:Float = 0.3;
	public static inline final ALPHA_STATS_BG:Float = 0.55;
}
