package glue.effects;

import glue.Glue;
import glue.scene.Scene;
import glue.scene.SceneManager;
import glue.style.Palette;
import glue.utils.Time;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Sprite;

/**
 * Scene transitions with various effects.
 *
 * Usage:
 *   Transition.fade(NextScene);
 *   Transition.pixelate(NextScene, 0.5);
 *   Transition.slideLeft(NextScene);
 *   Transition.circleOut(NextScene, Palette.VOID);
 */
class Transition
{
	static var _overlay:Sprite;
	static var _isTransitioning:Bool = false;
	static var _callback:Void->Void;

	/**
	 * Fade to black transition
	 */
	public static function fade<T:Scene>(scene:Class<T>, duration:Float = 0.5, ?color:Int):Void
	{
		if (color == null) color = Palette.VOID;
		doTransition(scene, duration, FadeOut, color);
	}

	/**
	 * Pixelate transition
	 */
	public static function pixelate<T:Scene>(scene:Class<T>, duration:Float = 0.5):Void
	{
		doTransition(scene, duration, Pixelate, 0);
	}

	/**
	 * Circle wipe out from center
	 */
	public static function circleOut<T:Scene>(scene:Class<T>, duration:Float = 0.5, ?color:Int):Void
	{
		if (color == null) color = Palette.VOID;
		doTransition(scene, duration, CircleOut, color);
	}

	/**
	 * Circle wipe in to center
	 */
	public static function circleIn<T:Scene>(scene:Class<T>, duration:Float = 0.5, ?color:Int):Void
	{
		if (color == null) color = Palette.VOID;
		doTransition(scene, duration, CircleIn, color);
	}

	/**
	 * Slide left
	 */
	public static function slideLeft<T:Scene>(scene:Class<T>, duration:Float = 0.3):Void
	{
		doTransition(scene, duration, SlideLeft, 0);
	}

	/**
	 * Slide right
	 */
	public static function slideRight<T:Scene>(scene:Class<T>, duration:Float = 0.3):Void
	{
		doTransition(scene, duration, SlideRight, 0);
	}

	/**
	 * Slide up
	 */
	public static function slideUp<T:Scene>(scene:Class<T>, duration:Float = 0.3):Void
	{
		doTransition(scene, duration, SlideUp, 0);
	}

	/**
	 * Slide down
	 */
	public static function slideDown<T:Scene>(scene:Class<T>, duration:Float = 0.3):Void
	{
		doTransition(scene, duration, SlideDown, 0);
	}

	/**
	 * Horizontal blinds
	 */
	public static function blinds<T:Scene>(scene:Class<T>, duration:Float = 0.5, ?color:Int):Void
	{
		if (color == null) color = Palette.VOID;
		doTransition(scene, duration, Blinds, color);
	}

	/**
	 * Flash white then change
	 */
	public static function flash<T:Scene>(scene:Class<T>, duration:Float = 0.3):Void
	{
		doTransition(scene, duration, Flash, Palette.WHITE);
	}

	/**
	 * Check if currently transitioning
	 */
	public static var isActive(get, never):Bool;

	static function get_isActive():Bool
	{
		return _isTransitioning;
	}

	static function doTransition<T:Scene>(scene:Class<T>, duration:Float, type:TransitionType, color:Int):Void
	{
		if (_isTransitioning) return;
		_isTransitioning = true;

		// Create overlay
		_overlay = new Sprite();
		Glue.stage.addChild(_overlay);

		var halfDuration = duration / 2;
		var elapsed:Float = 0;
		var phase:Int = 0; // 0 = out, 1 = in

		var w = Glue.width;
		var h = Glue.height;

		// Animation loop
		var onFrame:Dynamic->Void = null;
		onFrame = function(_)
		{
			elapsed += Time.deltaTime;
			var progress = Math.min(1, elapsed / halfDuration);
			var g = _overlay.graphics;
			g.clear();

			if (phase == 0)
			{
				// Transition out
				drawTransition(g, type, color, progress, w, h, false);

				if (progress >= 1)
				{
					// Switch scene
					SceneManager.gotoScene(scene);
					phase = 1;
					elapsed = 0;
				}
			}
			else
			{
				// Transition in
				drawTransition(g, type, color, 1 - progress, w, h, true);

				if (progress >= 1)
				{
					// Done
					Glue.stage.removeEventListener(openfl.events.Event.ENTER_FRAME, onFrame);
					Glue.stage.removeChild(_overlay);
					_overlay = null;
					_isTransitioning = false;
				}
			}
		};

		Glue.stage.addEventListener(openfl.events.Event.ENTER_FRAME, onFrame);
	}

	static function drawTransition(g:Graphics, type:TransitionType, color:Int, progress:Float, w:Int, h:Int, isIn:Bool):Void
	{
		var eased = easeInOut(progress);

		switch (type)
		{
			case FadeOut:
				g.beginFill(color, eased);
				g.drawRect(0, 0, w, h);
				g.endFill();

			case Flash:
				var alpha = isIn ? (1 - progress) : progress;
				g.beginFill(color, alpha);
				g.drawRect(0, 0, w, h);
				g.endFill();

			case CircleOut:
				var maxRadius = Math.sqrt(w * w + h * h) / 2;
				var radius = maxRadius * (1 - eased);
				g.beginFill(color);
				g.drawRect(0, 0, w, h);
				g.endFill();
				// Cut out circle
				g.beginFill(0, 0);
				g.drawCircle(w / 2, h / 2, radius);
				g.endFill();

			case CircleIn:
				var maxRadius = Math.sqrt(w * w + h * h) / 2;
				var radius = maxRadius * eased;
				g.beginFill(color);
				g.drawCircle(w / 2, h / 2, radius);
				g.endFill();

			case SlideLeft:
				g.beginFill(Palette.VOID);
				var x = isIn ? -w + (w * progress) : w * eased;
				g.drawRect(x, 0, w, h);
				g.endFill();

			case SlideRight:
				g.beginFill(Palette.VOID);
				var x = isIn ? w - (w * progress) : -w * eased;
				g.drawRect(x, 0, w, h);
				g.endFill();

			case SlideUp:
				g.beginFill(Palette.VOID);
				var y = isIn ? -h + (h * progress) : h * eased;
				g.drawRect(0, y, w, h);
				g.endFill();

			case SlideDown:
				g.beginFill(Palette.VOID);
				var y = isIn ? h - (h * progress) : -h * eased;
				g.drawRect(0, y, w, h);
				g.endFill();

			case Blinds:
				var numBlinds = 10;
				var blindHeight = h / numBlinds;
				g.beginFill(color);
				for (i in 0...numBlinds)
				{
					var bh = blindHeight * eased;
					g.drawRect(0, i * blindHeight, w, bh);
				}
				g.endFill();

			case Pixelate:
				// Pixelate effect (simplified - just blocks)
				var blockSize = Std.int(2 + (30 * eased));
				g.beginFill(Palette.VOID, eased * 0.8);
				g.drawRect(0, 0, w, h);
				g.endFill();
		}
	}

	static function easeInOut(t:Float):Float
	{
		return t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
	}
}

private enum TransitionType
{
	FadeOut;
	Flash;
	CircleOut;
	CircleIn;
	SlideLeft;
	SlideRight;
	SlideUp;
	SlideDown;
	Blinds;
	Pixelate;
}
