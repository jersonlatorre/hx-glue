package glue.style;

/**
 * Glue color palette - 16 curated colors for consistent visual identity.
 * Inspired by fantasy console aesthetics.
 *
 * Usage:
 *   var color = Palette.CORAL;
 *   Shape.circle(32).fill(Palette.SKY);
 *   graphics.beginFill(Palette.MIDNIGHT);
 */
class Palette
{
	// Darks
	public static inline var VOID:Int = 0x1a1c2c;       // Darkest
	public static inline var MIDNIGHT:Int = 0x333c57;   // Dark blue-gray
	public static inline var STORM:Int = 0x566c86;      // Medium blue-gray
	public static inline var STEEL:Int = 0x94b0c2;      // Light blue-gray

	// Colors
	public static inline var PURPLE:Int = 0x5d275d;     // Deep purple
	public static inline var CRIMSON:Int = 0xb13e53;    // Red
	public static inline var CORAL:Int = 0xef7d57;      // Orange
	public static inline var GOLD:Int = 0xffcd75;       // Yellow
	public static inline var LIME:Int = 0xa7f070;       // Light green
	public static inline var GRASS:Int = 0x38b764;      // Green
	public static inline var TEAL:Int = 0x257179;       // Dark teal
	public static inline var NAVY:Int = 0x29366f;       // Dark blue
	public static inline var ROYAL:Int = 0x3b5dc9;      // Blue
	public static inline var SKY:Int = 0x41a6f6;        // Light blue
	public static inline var CYAN:Int = 0x73eff7;       // Cyan

	// Light
	public static inline var WHITE:Int = 0xf4f4f4;      // Off-white

	// All colors indexed
	public static var all:Array<Int> = [
		VOID, MIDNIGHT, STORM, STEEL,
		PURPLE, CRIMSON, CORAL, GOLD,
		LIME, GRASS, TEAL, NAVY,
		ROYAL, SKY, CYAN, WHITE
	];

	// Semantic aliases
	public static inline var BACKGROUND:Int = VOID;
	public static inline var TEXT:Int = WHITE;
	public static inline var PRIMARY:Int = SKY;
	public static inline var SECONDARY:Int = CORAL;
	public static inline var SUCCESS:Int = GRASS;
	public static inline var WARNING:Int = GOLD;
	public static inline var DANGER:Int = CRIMSON;
	public static inline var MUTED:Int = STORM;

	/**
	 * Get color by index (0-15)
	 */
	public static function get(index:Int):Int
	{
		if (index < 0) index = 0;
		if (index >= all.length) index = all.length - 1;
		return all[index];
	}

	/**
	 * Get a random palette color
	 */
	public static function random():Int
	{
		return all[Std.random(all.length)];
	}

	/**
	 * Lighten a color (move towards WHITE)
	 */
	public static function lighter(color:Int):Int
	{
		var index = all.indexOf(color);
		if (index == -1) return color;

		// Simple mapping to lighter variants
		return switch (color)
		{
			case VOID: MIDNIGHT;
			case MIDNIGHT: STORM;
			case STORM: STEEL;
			case STEEL: WHITE;
			case PURPLE: CRIMSON;
			case CRIMSON: CORAL;
			case CORAL: GOLD;
			case NAVY: ROYAL;
			case ROYAL: SKY;
			case SKY: CYAN;
			case TEAL: GRASS;
			case GRASS: LIME;
			default: WHITE;
		};
	}

	/**
	 * Darken a color (move towards VOID)
	 */
	public static function darker(color:Int):Int
	{
		return switch (color)
		{
			case WHITE: STEEL;
			case STEEL: STORM;
			case STORM: MIDNIGHT;
			case MIDNIGHT: VOID;
			case CYAN: SKY;
			case SKY: ROYAL;
			case ROYAL: NAVY;
			case LIME: GRASS;
			case GRASS: TEAL;
			case GOLD: CORAL;
			case CORAL: CRIMSON;
			case CRIMSON: PURPLE;
			default: VOID;
		};
	}
}
