package glue.utils;
	
import haxe.Timer;
import glue.display.GBitmapText;
import openfl.events.Event;
import openfl.system.System;
import openfl.display.Sprite;
import openfl.display.Shape;

@:final class GStats extends Sprite
{
	private var labelFPS:GBitmapText;
	private var textFPS:GBitmapText;
	private var labelMEM:GBitmapText;
	private var textMEM:GBitmapText;

	private var background:Shape;
	private var graph:Shape;

	private var times:Array<Float>;
	private var fps:Int;
	private var systemFPS:Int;
	private var memoryPeak:Float = 0;
	private var memory:Float = 0;

	static var STATS_WIDTH:Int;
	static var STATS_HEIGHT:Int;
	static inline var BAR_WIDTH:Int = 150;
	static inline var BAR_HEIGHT:Int = 14;
	static inline var MARGIN:Int = 2;
	static inline var TEXT_WIDTH:Int = 40;
	static inline var FONT_SIZE:Float = 2;

	public function new(x:Int = 0, y:Int = 0)
	{
		super();
		
		this.x = x;
		this.y = y;

		systemFPS = Std.int(Glue.stage.frameRate);

		STATS_WIDTH = TEXT_WIDTH + BAR_WIDTH + MARGIN;
		STATS_HEIGHT = 2 * BAR_HEIGHT + 3 * MARGIN;
		
		labelFPS = new GBitmapText();
		labelFPS.position.x = 4;
		labelFPS.position.y = 4;
		labelFPS.size = FONT_SIZE;
		labelFPS.preUpdate();

		labelMEM = new GBitmapText();
		labelMEM.position.x = 4;
		labelMEM.position.y = 20;
		labelMEM.size = FONT_SIZE;
		labelMEM.preUpdate();

		textFPS = new GBitmapText();
		textFPS.position.x = TEXT_WIDTH + 4;
		textFPS.position.y = 4;
		textFPS.size = FONT_SIZE;
		textFPS.preUpdate();

		textMEM = new GBitmapText();
		textMEM.position.x = TEXT_WIDTH + 4;
		textMEM.position.y = 20;
		textMEM.size = FONT_SIZE;
		textMEM.preUpdate();

		labelFPS.text = 'FPS';
		labelMEM.text = 'MEM';

		background = new Shape();
		background.graphics.beginFill(0x000000, 0.55);
		background.graphics.drawRect(0, 0, STATS_WIDTH, STATS_HEIGHT);
		background.graphics.endFill();

		graph = new Shape();

		addChild(background);
		addChild(graph);
		
		labelFPS.addToLayer(this);
		labelMEM.addToLayer(this);
		textFPS.addToLayer(this);
		textMEM.addToLayer(this);
		
		times = [];
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private inline function update(e:Event)
	{
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1) times.shift();

		fps = if (times.length > systemFPS) systemFPS else times.length;
			
		memory = Std.int(System.totalMemory >> 20);
		if (memory > memoryPeak) memoryPeak = memory;

		textFPS.text = '${ fps }/${ systemFPS }';
		textMEM.text = '${ memory } Mb/${ memoryPeak } Mb';
		
		graph.graphics.clear();
		graph.graphics.beginFill(0xAAAAAA);
		graph.graphics.drawRect(TEXT_WIDTH, MARGIN, BAR_WIDTH, BAR_HEIGHT);
		graph.graphics.beginFill(0xAAAAAA);
		graph.graphics.drawRect(TEXT_WIDTH, BAR_HEIGHT + (MARGIN << 1), BAR_WIDTH, BAR_HEIGHT);
		graph.graphics.beginFill(0x119922);
		graph.graphics.drawRect(TEXT_WIDTH, MARGIN, BAR_WIDTH * fps / systemFPS , BAR_HEIGHT);
		graph.graphics.beginFill(0xEE4400);
		graph.graphics.drawRect(TEXT_WIDTH, BAR_HEIGHT + (MARGIN << 1), BAR_WIDTH * memory / if(memoryPeak == 0) 1 else memoryPeak, BAR_HEIGHT);
		graph.graphics.endFill();

	}
}