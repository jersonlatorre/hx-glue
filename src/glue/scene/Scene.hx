package glue.scene;

import glue.Glue;
import glue.GlueContext;
import glue.assets.AssetRequest;
import glue.assets.Loader;
import glue.input.Input;
import glue.input.InputActions;
import glue.math.Constants;
import glue.scene.Camera;
import glue.utils.Time;
import glue.utils.Tools;
import motion.Actuate;
import motion.easing.Quad;
import openfl.display.Shape;
import openfl.display.Sprite;

class Scene extends ViewBase
{
	var sceneCanvas:Sprite;
	var effectCanvas:Sprite;

	public var camera:Camera;

	public var deltaTime(get, never):Float;
	public var time(get, never):Float;
	public var framerate(get, never):Float;

	inline function get_deltaTime():Float return Time.deltaTime;
	inline function get_time():Float return Time.timelapse;
	inline function get_framerate():Float return Time.framerate;

	public function new(context:GlueContext)
	{
		super(context);
	}

	public function preInit():Void
	{
		if (Glue.isDebug) haxe.Log.trace('[ Scene: ${ Tools.getClassName(this) } ]', null);

		canvas = new Sprite();
		context.canvas.addChild(canvas);

		sceneCanvas = new Sprite();
		canvas.addChild(sceneCanvas);

		effectCanvas = new Sprite();
		canvas.addChild(effectCanvas);

		layerRoot = sceneCanvas;
		layers = new Map<String, Sprite>();
		entities = [];
		addLayer("default");

		context.stage.focus = sceneCanvas;

		camera = new Camera();

		if (usesMask())
		{
			ensureMask();
		}
		else
		{
			clearMask();
		}

		queueAssetRequests();

		preload();
		Loader.startDownload(init);
	}

	public function gotoScene(sceneClass:Class<Scene>):Void
	{
		SceneManager.gotoScene(sceneClass);
	}

	public var load = Glue.load;

	public function addAction(name:String, keys:Array<Int>):Void
	{
		Input.bindKeys(name, keys);
	}

	public function addActions(actions:Map<String, Array<Int>>):Void
	{
		for (name => keys in actions)
		{
			Input.bindKeys(name, keys);
		}
	}

	public function addWASD():Void
	{
		InputActions.bindWASD();
	}

	public function addArrows():Void
	{
		InputActions.bindArrows();
	}

	public function addWASDAndArrows():Void
	{
		InputActions.bindWASDAndArrows();
	}

	public function getDirection(left:String = "left", right:String = "right", up:String = "up", down:String = "down"):glue.math.Vector2D
	{
		return InputActions.getDirection(left, right, up, down);
	}

	public function getHorizontal(left:String = "left", right:String = "right"):Float
	{
		return InputActions.getHorizontal(left, right);
	}

	public function getVertical(up:String = "up", down:String = "down"):Float
	{
		return InputActions.getVertical(up, down);
	}

	public function isPressed(action:String):Bool
	{
		return Input.isKeyPressed(action);
	}

	public function isDown(action:String):Bool
	{
		return Input.isKeyDown(action);
	}

	public function isUp(action:String):Bool
	{
		return Input.isKeyUp(action);
	}

	public override function assetRequests():Array<AssetRequest>
	{
		return [];
	}

	public function preload():Void {}

	public function init():Void {}

	public function update():Void {}

	@:allow(glue.scene.SceneManager)
	function preUpdate():Void
	{
		if (!Loader.isDownloading)
		{
			update();
		}

		camera.update();

		sceneCanvas.x = -camera.position.x + context.width / 2;
		sceneCanvas.y = -camera.position.y + context.height / 2;

		updateEntities();
	}

	public function fadeIn(duration:Float = Constants.DEFAULT_FADE_DURATION):Void
	{
		var fade = new Shape();
		fade.graphics.beginFill(Constants.COLOR_BLACK);
		fade.graphics.drawRect(0, 0, context.width, context.height);
		fade.graphics.endFill();

		fade.x = 0;
		fade.y = 0;

		effectCanvas.addChild(fade);

		Actuate.tween(fade, duration, { alpha: Constants.ALPHA_TRANSPARENT }).ease(Quad.easeInOut).onComplete(function()
		{
			effectCanvas.removeChild(fade);
		});
	}

	public function fadeOut(duration:Float = Constants.DEFAULT_FADE_DURATION, callback:()->Void):Void
	{
		var fade = new Shape();
		fade.graphics.beginFill(Constants.COLOR_BLACK);
		fade.graphics.drawRect(0, 0, context.width, context.height);
		fade.graphics.endFill();

		fade.alpha = Constants.ALPHA_TRANSPARENT;
		fade.x = 0;
		fade.y = 0;

		effectCanvas.addChild(fade);

		Actuate.tween(fade, duration, { alpha: Constants.ALPHA_OPAQUE }).ease(Quad.easeInOut).onComplete(function()
		{
			effectCanvas.removeChild(fade);
			callback();
		});
	}

	public function destroy():Void
	{
		clearMask();
		mask = null;

		while (sceneCanvas != null && sceneCanvas.numChildren > 0)
		{
			sceneCanvas.removeChildAt(0);
		}
		while (effectCanvas != null && effectCanvas.numChildren > 0)
		{
			effectCanvas.removeChildAt(0);
		}

		if (context.canvas.contains(canvas))
		{
			context.canvas.removeChild(canvas);
		}

		destroyEntities();
		entities = [];
		layers = new Map<String, Sprite>();
		sceneCanvas = null;
		effectCanvas = null;
		canvas = null;
	}

	public function onResize():Void
	{
		updateMask();
	}

	function usesMask():Bool
	{
		return true;
	}
}
