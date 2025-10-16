package glue.scene;

import glue.Glue;
import glue.GlueContext;
import glue.assets.GAssetRequest;
import glue.assets.GLoader;
import glue.display.GEntity;
import glue.utils.GTools;
import openfl.display.Sprite;

class GPopup extends GViewBase
{
	var popupCanvas:Sprite;

	public function new(context:GlueContext)
	{
		super(context);
	}

	public function preInit():Void
	{
		if (Glue.isDebug) haxe.Log.trace('[ Popup: ${ GTools.getClassName(this) } ]' , null);

		canvas = new Sprite();
		context.canvas.addChild(canvas);

		popupCanvas = new Sprite();
		canvas.addChild(popupCanvas);

		layerRoot = popupCanvas;
		layers = new Map<String, Sprite>();
		entities = [];
		addLayer("default");

		context.stage.focus = popupCanvas;

		if (usesMask())
		{
			ensureMask();
		}
		else
		{
			clearMask();
		}

		queueAssetRequests();

		init();
	}

	public function gotoScene(sceneClass:Class<GScene>):Void
	{
		GSceneManager.gotoScene(sceneClass);
	}

	public function init():Void {}

	public function update():Void {}

	public override function assetRequests():Array<GAssetRequest>
	{
		return [];
	}

	@:allow(glue.scene.GSceneManager)
	function preUpdate():Void
	{
		update();
		updateEntities();
	}

	public function destroy():Void
	{
		while (popupCanvas != null && popupCanvas.numChildren > 0)
		{
			popupCanvas.removeChildAt(0);
		}

		if (canvas != null && context.canvas.contains(canvas))
		{
			context.canvas.removeChild(canvas);
		}

		clearMask();
		mask = null;

		destroyEntities();
		entities = [];
		layers = new Map<String, Sprite>();
		popupCanvas = null;
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
