package plug;

/**
 * ...
 * @author Uno
 */

class AssetsData
{
	static public var info:Array<Dynamic> =
	[
		// [ ------ images ------ ]
		{ type:"image", url:"img/background_scorecard.png", id:"background_scorecard" },
		{ type:"image", url:"img/background_menu.png", id:"background_menu" },
		{ type:"image", url:"img/background_game.png", id:"background_game" },
		
		// [ ------ sprites ------ ]
		{ type:"sprite", url:"img/button_play", id:"button_play" },
		{ type:"sprite", url:"img/button_replay", id:"button_replay" },
		
		{ type:"sprite", url:"img/item_bad_1_stand", id:"item_bad_1_stand" },
		{ type:"sprite", url:"img/item_bad_1_die", id:"item_bad_1_die" },
		{ type:"sprite", url:"img/item_good_1_stand", id:"item_good_1_stand" },
		{ type:"sprite", url:"img/item_good_1_die", id:"item_good_1_die" },
		
		{ type:"sprite", url:"img/item_bad_2_stand", id:"item_bad_2_stand" },
		{ type:"sprite", url:"img/item_bad_2_die", id:"item_bad_2_die" },
		{ type:"sprite", url:"img/item_good_2_stand", id:"item_good_2_stand" },
		{ type:"sprite", url:"img/item_good_2_die", id:"item_good_2_die" },
		
		{ type:"sprite", url:"img/item_bad_3_stand", id:"item_bad_3_stand" },
		{ type:"sprite", url:"img/item_bad_3_die", id:"item_bad_3_die" },
		{ type:"sprite", url:"img/item_good_3_stand", id:"item_good_3_stand" },
		{ type:"sprite", url:"img/item_good_3_die", id:"item_good_3_die" },
		
		{ type:"sprite", url:"img/player_stand", id:"player_stand" },
		{ type:"sprite", url:"img/player_walk", id:"player_walk" },
		{ type:"sprite", url:"img/player_die", id:"player_die" },
		
		// [ ------ data ------ ]
		{ type:"data", url:"data/config.json", id:"config" },
		{ type:"data", url:"fonts/font.fnt", id:"font" },
		
		// [ ------ bitmapfont ------ ]
		{ type:"bitmapfont", url:"fonts/font", id:"font" },
		
		// [ ------ sound ------ ]
		#if flash
		{ type:"sound", url:"sound/bgm_game.mp3", id:"bgm_game", group:"bgm" },
		{ type:"sound", url:"sound/bgm_menu.mp3", id:"bgm_menu", group:"bgm" },
		{ type:"sound", url:"sound/button_down.mp3", id:"button_down", group:"effects" },
		{ type:"sound", url:"sound/button_over.mp3", id:"button_over", group:"effects" },
		{ type:"sound", url:"sound/player_die.mp3", id:"die", group:"effects" },
		{ type:"sound", url:"sound/player_good.mp3", id:"good", group:"effects" },
		{ type:"sound", url:"sound/player_lose.mp3", id:"lose", group:"effects" }
		#else
		{ type:"sound", url:"sound/bgm_game.ogg", id:"bgm_game", group:"bgm" },
		{ type:"sound", url:"sound/bgm_menu.ogg", id:"bgm_menu", group:"bgm" },
		{ type:"sound", url:"sound/button_down.ogg", id:"button_down", group:"effects" },
		{ type:"sound", url:"sound/button_over.ogg", id:"button_over", group:"effects" },
		{ type:"sound", url:"sound/player_die.ogg", id:"die", group:"effects" },
		{ type:"sound", url:"sound/player_good.ogg", id:"good", group:"effects" },
		{ type:"sound", url:"sound/player_lose.ogg", id:"lose", group:"effects" }
		#end
	];
}