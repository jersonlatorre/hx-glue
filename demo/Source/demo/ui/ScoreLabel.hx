package demo.ui;

import glue.display.GEntity;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

class ScoreLabel extends GEntity
{
	var textField:TextField;
	var format:TextFormat;

	public function new()
	{
		super();

		anchor.set(0, 0);

		format = new TextFormat("_sans", 20, 0xFFFFFF, true);

		textField = new TextField();
		textField.defaultTextFormat = format;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.selectable = false;
		textField.text = "Score: 0";
		_skin.addChild(textField);

		updateBounds();
	}

	public function setScore(value:Int)
	{
		textField.text = 'Score: $value';
		updateBounds();
	}

	function updateBounds()
	{
		width = textField.textWidth + 4;
		height = textField.textHeight + 4;
		bounds.setTo(0, 0, width, height);
	}
}
