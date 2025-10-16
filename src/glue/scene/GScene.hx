package glue.scene;

import glue.Glue;
import glue.GlueContext;
import glue.assets.GAssetRequest;
import glue.assets.GLoader;
import glue.math.GConstants;
import glue.scene.GCamera;
import glue.utils.GTools;
import motion.Actuate;
import motion.easing.Quad;
import openfl.display.Shape;
import openfl.display.Sprite;

class GScene extends GViewBase
{
	var sceneCanvas:Sprite;
	var effectCanvas:Sprite;

	public var camera:GCamera;

	public function new(context:GlueContext)
	{
		super(context);
	}

	public function preInit():Void
	{
		if (Glue.isDebug) haxe.Log.trace('[ Scene: ${ GTools.getClassName(this) } ]', null);

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

		camera = new GCamera();

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
		GLoader.startDownload(init);
	}

	public function gotoScene(sceneClass:Class<GScene>):Void
	{
		GSceneManager.gotoScene(sceneClass);
	}

	public var load = Glue.load;

	public override function assetRequests():Array<GAssetRequest>
	{
		return [];
	}

	public function preload():Void {}

	public function init():Void {}

	public function update():Void {}

	@:allow(glue.scene.GSceneManager)
	function preUpdate():Void
	{
		if (!GLoader.isDownloading)
		{
			update();
		}

		camera.update();

		sceneCanvas.x = -camera.position.x + context.width / 2;
		sceneCanvas.y = -camera.position.y + context.height / 2;

		updateEntities();
	}

	public function fadeIn(duration:Float = GConstants.DEFAULT_FADE_DURATION):Void
	{
		var fade = new Shape();
		fade.graphics.beginFill(GConstants.COLOR_BLACK);
		fade.graphics.drawRect(0, 0, context.width, context.height);
		fade.graphics.endFill();

		fade.x = 0;
		fade.y = 0;

		effectCanvas.addChild(fade);

		Actuate.tween(fade, duration, { alpha: GConstants.ALPHA_TRANSPARENT }).ease(Quad.easeInOut).onComplete(function()
		{
			effectCanvas.removeChild(fade);
		});
	}

	public function fadeOut(duration:Float = GConstants.DEFAULT_FADE_DURATION, callback:()->Void):Void
	{
		var fade = new Shape();
		fade.graphics.beginFill(GConstants.COLOR_BLACK);
		fade.graphics.drawRect(0, 0, context.width, context.height);
		fade.graphics.endFill();

		fade.alpha = GConstants.ALPHA_TRANSPARENT;
		fade.x = 0;
		fade.y = 0;

		effectCanvas.addChild(fade);

		Actuate.tween(fade, duration, { alpha: GConstants.ALPHA_OPAQUE }).ease(Quad.easeInOut).onComplete(function()
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
