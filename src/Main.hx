package;

import com.glue.GEngine;
import com.glue.utils.GStats;
import com.plug.AssetsData;
import com.plug.ui.SceneMenu;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Uno
 */
class Main extends Sprite 
{
	public function new()
	{
		super();
		
		GEngine.isEmbedded = false;
		GEngine.assetsInfo = AssetsData.info;
		GEngine.mainScreen = SceneMenu;
		
		//GLoader.basePath = "img/";
		//GLoader.queueFile({ type:"image", url:"background_scorecard.png", id:"background_scorecard" });
		//GLoader.queueFile({ type:"image", url:"background_scorecard.png", id:"background_scorecard" });
		
		GEngine.start({
			stage: stage,
			width: 800,
			height: 600,
			mainScene: SceneMenu,
			idEmbedded: true
		});
	}
}
