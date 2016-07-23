package com.plug;
import com.glue.ui.GScene;
import com.plug.ui.SceneGame;
import openfl.geom.Point;

/**
 * ...
 * @author Uno
 */

class Global
{
	static public var score:Int = 0;
	static public var game:SceneGame;
	
	static public var isDebug:Bool;
	static public var playButtonPosition:Point = new Point();
	static public var replayButtonPosition:Point = new Point();
	static public var scoreGamePosition:Point = new Point();
	static public var scoreFinalPosition:Point = new Point();
	static public var scene:GScene;
	
	public function new() 
	{
	}
}