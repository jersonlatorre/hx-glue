package glue.display;

import haxe.Utf8;
import haxe.xml.Fast;
import glue.assets.GLoader;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * Class for rendering text with provided bitmap font and some additional options.
 */
class GBitmapText extends GEntity 
{
	/**
	 * Font for text rendering.
	 */
	public var font(default, set):GBitmapFont;
	
	/**
	 * Text to display.
	 */
	public var text(default, set):String = "";
	
	/**
	 * Helper array which contains actual strings for rendering.
	 */
	private var _lines:Array<String> = [];
	/**
	 * Helper array which contains width of each displayed lines.
	 */
	private var _linesWidth:Array<Float> = [];
	
	/**
	 * Specifies how the text field should align text.
	 */
	public var alignment(default, set):GBitmapTextAlign = GBitmapTextAlign.LEFT;
	
	/**
	 * The distance to add between lines.
	 */
	public var lineSpacing(default, set):Int = 0;
	
	/**
	 * The distance to add between letters.
	 */
	public var letterSpacing(default, set):Int = 0;
	
	/**
	 * Whether to convert text to upper case or not.
	 */
	public var autoUpperCase(default, set):Bool = false;
	
	/**
	 * A Boolean value that indicates whether the text field has word wrap.
	 */
	public var wordWrap(default, set):Bool = true;
	
	/**
	 * Whether word wrapping algorithm should wrap lines by words or by single character.
	 * Default value is true.
	 */ 
	public var wrapByWord(default, set):Bool = true;
	
	/**
	 * Whether this text field have fixed width or not.
	 * Default value if true.
	 */
	public var autoSize(default, set):Bool = true;
	
	/**
	 * Number of pixels between text and text field border
	 */
	public var padding(default, set):Int = 0;
	
	/**
	 * Width of the text in this text field.
	 */
	public var textWidth(get, null):Float;
	
	/**
	 * Height of the text in this text field.
	 */
	public var textHeight(get, null):Float;
	
	/**
	 * Height of the single line of text (without lineSpacing).
	 */
	public var lineHeight(get, null):Float;
	
	/**
	 * Number of space characters in one tab.
	 */
	public var numSpacesInTab(default, set):Int = 4;
	private var _tabSpaces:String = "    ";
	
	/**
	 * The color of the text in 0xAARRGGBB format.
	 */
	public var textColor(default, set):UInt = 0xFFFFFFFF;
	
	/**
	 * Whether to use textColor while rendering or not.
	 */
	public var useTextColor(default, set):Bool = false;
	
	/**
	 * Use a border style
	 */	
	public var borderStyle(default, set):GBitmapTextBorderStyle = NONE;
	
	/**
	 * The color of the border in 0xAARRGGBB format
	 */
	public var borderColor(default, set):UInt = 0xFF000000;
	
	/**
	 * The size of the border, in pixels.
	 */
	public var borderSize(default, set):Float = 1;
	
	/**
	 * How many iterations do use when drawing the border. 0: only 1 iteration, 1: one iteration for every pixel in borderSize
	 * A value of 1 will have the best quality for large border sizes, but might reduce performance when changing text. 
	 * NOTE: If the borderSize is 1, borderQuality of 0 or 1 will have the exact same effect (and performance).
	 */
	public var borderQuality(default, set):Float = 0;
	
	/**
	 * Offset that is applied to the shadow border style, if active. 
	 * x and y are multiplied by borderSize. Default is (1, 1), or lower-right corner.
	 */
	public var shadowOffset(default, null):Point;
	
	/**
	 * Specifies whether the text should have background
	 */
	public var background(default, set):Bool = false;
	
	/**
	 * Specifies the color of background in 0xAARRGGBB format.
	 */
	public var backgroundColor(default, set):UInt = 0x00000000;
	
	/**
	 * Specifies whether the text field will break into multiple lines or not on overflow.
	 */
	public var multiLine(default, set):Bool = true;
	
	/**
	 * Reflects how many lines have this text field.
	 */
	public var numLines(get, null):Int = 0;
	
	/**
	 * The "size" (scale) of the font.
	 */
	public var size(default, set):Float = 1;
	
	public var smoothing(default, set):Bool;
	
	/**
	 * Whether graphics/bitmapdata of this text field should be updated immediately after each setter call.
	 * Default value is true which means that graphics will be updated/regenerated after each setter call,
	 * which could be CPU-heavy.
	 * So if you want to save some CPU resources then you could set updateImmediately to false,
	 * make all operations with this text field (change text color, size, border style, etc.).
	 * and then set updateImmediately back to true which will immediately update graphics of this text field. 
	 */
	public var updateImmediately(default, set):Bool = true;
	
	private var _pendingTextChange:Bool = true;
	private var _pendingGraphicChange:Bool = true;
	
	private var _pendingTextGlyphsChange:Bool = true;
	private var _pendingBorderGlyphsChange:Bool = false;
	
	private var _fieldWidth:Int = 1;
	private var _fieldHeight:Int = 1;
	
	private var _bitmap:Bitmap;
	private var _bitmapData:BitmapData;
	
	/**
	 * Glyphs for text rendering. Used only in blit render mode.
	 */
	private var textGlyphs:GBitmapGlyphCollection;
	/**
	 * Glyphs for border (shadow or outline) rendering.
	 * Used only in blit render mode.
	 */
	private var borderGlyphs:GBitmapGlyphCollection;
	
	private var _point:Point;
	
	/**
	 * Constructs a new text field component.
	 * @param font	optional parameter for component's font prop
	 * @param text	optional parameter for component's text
	 */
	public function new(?font:GBitmapFont, text:String = "", pixelSnapping:PixelSnapping = null, smoothing:Bool = false)
	{
		super();
		
		shadowOffset = new Point(1, 1);
		
		pixelSnapping = (pixelSnapping == null) ? PixelSnapping.AUTO : pixelSnapping;
		_bitmapData = new BitmapData(_fieldWidth, _fieldHeight, true, 0x00000000);
		_bitmap = new Bitmap(_bitmapData, pixelSnapping, smoothing);
		_skin.addChild(_bitmap);
		_point = new Point();
		
		if (font == null)
		{
			font = GBitmapFont.getDefaultFont();
		}

		width = _skin.width;
		height = _skin.height;
		
		this.font = font;
		this.text = text;
		this.smoothing = smoothing;
	}

	static public function fromAngelCode(idBitmap:String, idData:String):GBitmapText
	{
		var fontImage:BitmapData = GLoader.getImage(idBitmap);
		var fontXml:Xml = GLoader.getXml(idData);
		var font:GBitmapFont = GBitmapFont.fromAngelCode(fontImage, fontXml);
		var angelCodeText = new GBitmapText(font);
		return angelCodeText;
	}

	static public function fromMonospace(idBitmap:String, chars:String, charWidth:Int, charHeight:Int):GBitmapText
	{
		var fontImage:BitmapData = GLoader.getImage(idBitmap);
		var font:GBitmapFont = GBitmapFont.fromMonospace(idBitmap, fontImage, chars, new Point(charWidth, charHeight));
		var monospaceText = new GBitmapText(font);
		return monospaceText;
	}

	// public function addTo(scene:GScene, ?layer:String):GBitmapText
	// {
	// 	scene.addEntity(this, layer);
	// 	return this;
	// }
	
	/**
	 * Clears all resources used by this text field.
	 */
	public function dispose():Void 
	{
		updateImmediately = false;
		
		font = null;
		text = null;
		_lines = null;
		_linesWidth = null;
		shadowOffset = null;
		
		_point = null;
		
		if (textGlyphs != null)
		{
			textGlyphs.dispose();
		}
		textGlyphs = null;
		
		if (borderGlyphs != null)
		{
			borderGlyphs.dispose();
		}
		borderGlyphs = null;
		
		if (_bitmap != null)
		{
			_skin.removeChild(_bitmap);
		}
		_bitmap = null;
		
		if (_bitmapData != null)
		{
			_bitmapData.dispose();
		}
		_bitmapData = null;
	}
	
	/**
	 * Forces graphic regeneration for this text field immediately.
	 */
	public function forceGraphicUpdate():Void
	{
		_pendingGraphicChange = true;
		checkPendingChanges();
	}
	
	inline private function checkImmediateChanges():Void
	{
		if (updateImmediately)
		{
			checkPendingChanges();
		}
	}
	
	inline private function checkPendingChanges():Void
	{
		if (_pendingTextGlyphsChange)
		{
			updateTextGlyphs();
		}
		
		if (_pendingBorderGlyphsChange)
		{
			updateBorderGlyphs();
		}
		
		if (_pendingTextChange)
		{
			updateText();
			_pendingGraphicChange = true;
		}
		
		if (_pendingGraphicChange)
		{
			updateGraphic();
		}
	}
	
	private function set_textColor(value:UInt):UInt 
	{
		if (textColor != value)
		{
			textColor = value;
			_pendingTextGlyphsChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_useTextColor(value:Bool):Bool 
	{
		if (useTextColor != value)
		{
			useTextColor = value;
			_pendingTextGlyphsChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_text(value:String):String 
	{
		if (value != text && value != null)
		{
			text = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}

		width = _skin.width;
		height = _skin.height;
		
		return value;
	}
	
	private function updateText():Void 
	{
		var tmp:String = (autoUpperCase) ? text.toUpperCase() : text;
		
		_lines = tmp.split("\n");
		
		if (!autoSize)
		{
			if (wordWrap)
			{
				wrap();
			}
			else
			{
				cutLines();
			}
		}
		
		if (!multiLine)
		{
			_lines = [_lines[0]];
		}
		
		_pendingTextChange = false;
		_pendingGraphicChange = true;
	}
	
	/**
	 * Calculates the size of text field.
	 */
	private function computeTextSize():Void 
	{
		var txtWidth:Int = Math.ceil(_fieldWidth);
		var txtHeight:Int = Math.ceil(textHeight) + 2 * padding;
		
		var tw:Int = Math.ceil(textWidth);
		
		if (autoSize)
		{
			txtWidth = tw + 2 * padding;
		}
		else
		{
			txtWidth = Math.ceil(_fieldWidth);
		}
		
		_fieldWidth = (txtWidth == 0) ? 1 : txtWidth;
		_fieldHeight = (txtHeight == 0) ? 1 : txtHeight;

		// width = _skin.width;
		// height = _skin.height;
	}
	
	/**
	 * Calculates width of the line with provided index
	 * 
	 * @param	lineIndex	index of the line in _lines array
	 * @return	The width of the line
	 */
	public function getLineWidth(lineIndex:Int):Float
	{
		if (lineIndex < 0 || lineIndex >= _lines.length)
		{
			return 0;
		}
		
		return getStringWidth(_lines[lineIndex]);
	}
	
	/**
	 * Calculates width of provided string (for current font with fontScale).
	 * 
	 * @param	str	String to calculate width for
	 * @return	The width of result bitmap text.
	 */
	public function getStringWidth(str:String):Float
	{
		var spaceWidth:Float = Math.ceil(font.spaceWidth * size);
		var tabWidth:Float = Math.ceil(spaceWidth * numSpacesInTab);
		
		var lineLength:Int = Utf8.length(str);	// lenght of the current line
		var lineWidth:Float = Math.ceil(Math.abs(font.minOffsetX) * size);
		
		var charCode:Int;
		var charWidth:Float = 0;			// the width of current character
		
		var widthPlusOffset:Int = 0;
		var glyphFrame:GBitmapGlyphFrame;
		
		for (c in 0...lineLength)
		{
			charCode = Utf8.charCodeAt(str, c);
			
			if (charCode == GBitmapFont.spaceCode)
			{
				charWidth = spaceWidth;
			}
			else if (charCode == GBitmapFont.tabCode)
			{
				charWidth = tabWidth;
			}
			else
			{
				if (font.glyphs.exists(charCode))
				{
					glyphFrame = font.glyphs.get(charCode);
					charWidth = Math.ceil(glyphFrame.xadvance * size);
					
					if (c == (lineLength - 1))
					{
						widthPlusOffset = Math.ceil((glyphFrame.xoffset + glyphFrame.bitmap.width) * size); 
						if (widthPlusOffset > charWidth)
						{
							charWidth = widthPlusOffset;
						}
					}
				}
				else
				{
					charWidth = 0;
				}
			}
			
			lineWidth += (charWidth + letterSpacing);
		}
		
		if (lineLength > 0)
		{
			lineWidth -= letterSpacing;
		}
		
		return lineWidth;
	}
	
	/**
	 * Just cuts the lines which are too long to fit in the field.
	 */
	private function cutLines():Void 
	{
		var newLines:Array<String> = [];
		
		var lineLength:Int;			// lenght of the current line
		
		var c:Int;					// char index
		var char:String; 			// current character in word
		var charCode:Int;
		var charWidth:Float = 0;	// the width of current character
		
		var subLine:Utf8;			// current subline to assemble
		var subLineWidth:Float;		// the width of current subline
		
		var spaceWidth:Float = font.spaceWidth * size;
		var tabWidth:Float = spaceWidth * numSpacesInTab;
		
		var startX:Float = Math.abs(font.minOffsetX) * size;
		
		for (line in _lines)
		{
			lineLength = Utf8.length(line);
			subLine = new Utf8();
			subLineWidth = startX;
			
			c = 0;
			while (c < lineLength)
			{
				charCode = Utf8.charCodeAt(line, c);
				
				if (charCode == GBitmapFont.spaceCode)
				{
					charWidth = spaceWidth;
				}
				else if (charCode == GBitmapFont.tabCode)
				{
					charWidth = tabWidth;
				}
				else
				{
					charWidth = (font.glyphs.exists(charCode)) ? font.glyphs.get(charCode).xadvance * size : 0;
				}
				charWidth += letterSpacing;
				
				if (subLineWidth + charWidth > _fieldWidth - 2 * padding)
				{
					subLine.addChar(charCode);
					newLines.push(subLine.toString());
					subLine = new Utf8();
					subLineWidth = startX;
					c = lineLength;
				}
				else
				{
					subLine.addChar(charCode);
					subLineWidth += charWidth;
				}
				
				c++;
			}
		}
		
		_lines = newLines;
	}
	
	/**
	 * Automatically wraps text by figuring out how many characters can fit on a
	 * single line, and splitting the remainder onto a new line.
	 */
	private function wrap():Void
	{
		// subdivide lines
		var newLines:Array<String> = [];
		var words:Array<String>;			// the array of words in the current line
		
		for (line in _lines)
		{
			words = [];
			// split this line into words
			splitLineIntoWords(line, words);
			
			if (wrapByWord)
			{
				wrapLineByWord(words, newLines);
			}
			else
			{
				wrapLineByCharacter(words, newLines);
			}
		}
		
		_lines = newLines;
	}
	
	/**
	 * Helper function for splitting line of text into separate words.
	 * 
	 * @param	line	line to split.
	 * @param	words	result array to fill with words.
	 */
	private function splitLineIntoWords(line:String, words:Array<String>):Void
	{
		var word:String = "";				// current word to process
		var wordUtf8:Utf8 = new Utf8();
		var isSpaceWord:Bool = false; 		// whether current word consists of spaces or not
		var lineLength:Int = Utf8.length(line);	// lenght of the current line
		
		var hyphenCode:Int = Utf8.charCodeAt('-', 0);
		
		var c:Int = 0;						// char index on the line
		var charCode:Int; 					// code for the current character in word
		var charUtf8:Utf8;
		
		while (c < lineLength)
		{
			charCode = Utf8.charCodeAt(line, c);
			word = wordUtf8.toString();
			
			if (charCode == GBitmapFont.spaceCode || charCode == GBitmapFont.tabCode)
			{
				if (!isSpaceWord)
				{
					isSpaceWord = true;
					
					if (word != "")
					{
						words.push(word);
						wordUtf8 = new Utf8();
					}
				}
				
				wordUtf8.addChar(charCode);
			}
			else if (charCode == hyphenCode)
			{
				if (isSpaceWord && word != "")
				{
					isSpaceWord = false;
					words.push(word);
					words.push('-');
				}
				else if (isSpaceWord == false)
				{
					charUtf8 = new Utf8();
					charUtf8.addChar(charCode);
					words.push(word + charUtf8.toString());
				}
				
				wordUtf8 = new Utf8();
			}
			else
			{
				if (isSpaceWord && word != "")
				{
					isSpaceWord = false;
					words.push(word);
					wordUtf8 = new Utf8();
				}
				
				wordUtf8.addChar(charCode);
			}
			
			c++;
		}
		
		word = wordUtf8.toString();
		if (word != "") words.push(word);
	}
	
	/**
	 * Wraps provided line by words.
	 * 
	 * @param	words		The array of words in the line to process.
	 * @param	newLines	Array to fill with result lines.
	 */
	private function wrapLineByWord(words:Array<String>, newLines:Array<String>):Void
	{
		var numWords:Int = words.length;	// number of words in the current line
		var w:Int;							// word index in the current line
		var word:String;					// current word to process
		var wordWidth:Float;				// total width of current word
		var wordLength:Int;					// number of letters in current word
		
		var isSpaceWord:Bool = false; 		// whether current word consists of spaces or not
		
		var charCode:Int;
		var charWidth:Float = 0;			// the width of current character
		
		var subLines:Array<String> = [];	// helper array for subdividing lines
		
		var subLine:String;					// current subline to assemble
		var subLineWidth:Float;				// the width of current subline
		
		var spaceWidth:Float = font.spaceWidth * size;
		var tabWidth:Float = spaceWidth * numSpacesInTab;
		
		var startX:Float = Math.abs(font.minOffsetX) * size;
		
		if (numWords > 0)
		{
			w = 0;
			subLineWidth = startX;
			subLine = "";
			
			while (w < numWords)
			{
				wordWidth = 0;
				word = words[w];
				wordLength = Utf8.length(word);
				
				charCode = Utf8.charCodeAt(word, 0);
				isSpaceWord = (charCode == GBitmapFont.spaceCode || charCode == GBitmapFont.tabCode);
				
				for (c in 0...wordLength)
				{
					charCode = Utf8.charCodeAt(word, c);
					
					if (charCode == GBitmapFont.spaceCode)
					{
						charWidth = spaceWidth;
					}
					else if (charCode == GBitmapFont.tabCode)
					{
						charWidth = tabWidth;
					}
					else
					{
						charWidth = (font.glyphs.exists(charCode)) ? font.glyphs.get(charCode).xadvance * size : 0;
					}
					
					wordWidth += charWidth;
				}
				
				wordWidth += ((wordLength - 1) * letterSpacing);
				
				if (subLineWidth + wordWidth > _fieldWidth - 2 * padding)
				{
					if (isSpaceWord)
					{
						subLines.push(subLine);
						subLine = "";
						subLineWidth = startX;
					}
					else if (subLine != "") // new line isn't empty so we should add it to sublines array and start another one
					{
						subLines.push(subLine);
						subLine = word;
						subLineWidth = startX + wordWidth + letterSpacing;
					}
					else					// the line is too tight to hold even one word
					{
						subLine = word;
						subLineWidth = startX + wordWidth + letterSpacing;
					}
				}
				else
				{
					subLine += word;
					subLineWidth += wordWidth + letterSpacing;
				}
				
				w++;
			}
			
			if (subLine != "")
			{
				subLines.push(subLine);
			}
		}
		
		for (subline in subLines)
		{
			newLines.push(subline);
		}
	}
	
	/**
	 * Wraps provided line by characters (as in standart flash text fields).
	 * 
	 * @param	words		The array of words in the line to process.
	 * @param	newLines	Array to fill with result lines.
	 */
	private function wrapLineByCharacter(words:Array<String>, newLines:Array<String>):Void
	{
		var numWords:Int = words.length;	// number of words in the current line
		var w:Int;							// word index in the current line
		var word:String;					// current word to process
		var wordLength:Int;					// number of letters in current word
		
		var isSpaceWord:Bool = false; 		// whether current word consists of spaces or not
		
		var char:String; 					// current character in word
		var charCode:Int;
		var c:Int;							// char index
		var charWidth:Float = 0;			// the width of current character
		
		var subLines:Array<String> = [];	// helper array for subdividing lines
		
		var subLine:String;					// current subline to assemble
		var subLineUtf8:Utf8;
		var subLineWidth:Float;				// the width of current subline
		
		var spaceWidth:Float = font.spaceWidth * size;
		var tabWidth:Float = spaceWidth * numSpacesInTab;
		
		var startX:Float = Math.abs(font.minOffsetX) * size;
		
		if (numWords > 0)
		{
			w = 0;
			subLineWidth = startX;
			subLineUtf8 = new Utf8();
			
			while (w < numWords)
			{
				word = words[w];
				wordLength = Utf8.length(word);
				
				charCode = Utf8.charCodeAt(word, 0);
				isSpaceWord = (charCode == GBitmapFont.spaceCode || charCode == GBitmapFont.tabCode);
				
				c = 0;
				
				while (c < wordLength)
				{
					charCode = Utf8.charCodeAt(word, c);
					
					if (charCode == GBitmapFont.spaceCode)
					{
						charWidth = spaceWidth;
					}
					else if (charCode == GBitmapFont.tabCode)
					{
						charWidth = tabWidth;
					}
					else
					{
						charWidth = (font.glyphs.exists(charCode)) ? font.glyphs.get(charCode).xadvance * size : 0;
					}
					
					if (subLineWidth + charWidth > _fieldWidth - 2 * padding)
					{
						subLine = subLineUtf8.toString();
						
						if (isSpaceWord) // new line ends with space / tab char, so we push it to sublines array, skip all the rest spaces and start another line
						{
							subLines.push(subLine);
							c = wordLength;
							subLineUtf8 = new Utf8();
							subLineWidth = startX;
						}
						else if (subLine != "") // new line isn't empty so we should add it to sublines array and start another one
						{
							subLines.push(subLine);
							subLineUtf8 = new Utf8();
							subLineUtf8.addChar(charCode);
							subLineWidth = startX + charWidth + letterSpacing;
						}
						else	// the line is too tight to hold even one glyph
						{
							subLineUtf8 = new Utf8();
							subLineUtf8.addChar(charCode);
							subLineWidth = startX + charWidth + letterSpacing;
						}
					}
					else
					{
						subLineUtf8.addChar(charCode);
						subLineWidth += (charWidth + letterSpacing);
					}
					
					c++;
				}
				
				w++;
			}
			
			subLine = subLineUtf8.toString();
			
			if (subLine != "")
			{
				subLines.push(subLine);
			}
		}
		
		for (subline in subLines)
		{
			newLines.push(subline);
		}
	}
	
	/**
	 * Internal method for updating the view of the text component
	 */
	private function updateGraphic():Void 
	{
		computeTextSize();
		var colorForFill:Int = (background) ? backgroundColor : 0x00000000;
		if (_bitmapData == null || (_fieldWidth != _bitmapData.width || _fieldHeight != _bitmapData.height))
		{
			if (_bitmapData != null)
			{
				_bitmapData.dispose();
			}
			
			_bitmapData = new BitmapData(_fieldWidth, _fieldHeight, true, colorForFill);
			_bitmap.bitmapData = _bitmapData;
			_bitmap.smoothing = smoothing;
		}
		else 
		{
			_bitmapData.fillRect(_bitmapData.rect, colorForFill);
		}
		
		if (size > 0)
		{
			_bitmapData.lock();
			
			var numLines:Int = _lines.length;
			var line:String;
			var lineWidth:Float;
			
			var ox:Int, oy:Int;
			
			var iterations:Int = Std.int(borderSize * borderQuality);
			iterations = (iterations <= 0) ? 1 : iterations; 
			
			var delta:Int = Std.int(borderSize / iterations);
			
			var iterationsX:Int = 1;
			var iterationsY:Int = 1;
			var deltaX:Int = 1;
			var deltaY:Int = 1;
			
			if (borderStyle == GBitmapTextBorderStyle.SHADOW)
			{
				iterationsX = Math.round(Math.abs(shadowOffset.x) * borderQuality);
				iterationsX = (iterationsX <= 0) ? 1 : iterationsX;
				
				iterationsY = Math.round(Math.abs(shadowOffset.y) * borderQuality);
				iterationsY = (iterationsY <= 0) ? 1 : iterationsY;
				
				deltaX = Math.round(shadowOffset.x / iterationsX);
				deltaY = Math.round(shadowOffset.y / iterationsY);
			}
			
			// render border
			for (i in 0...numLines)
			{
				line = _lines[i];
				lineWidth = _linesWidth[i];
				
				// LEFT
				ox = Std.int(Math.abs(font.minOffsetX) * size);
				oy = Std.int(i * (font.lineHeight * size + lineSpacing)) + padding;
				
				if (alignment == GBitmapTextAlign.CENTER) 
				{
					ox += Std.int((_fieldWidth - lineWidth) * 0.5) - padding;
				}
				if (alignment == GBitmapTextAlign.RIGHT) 
				{
					ox += (_fieldWidth - Std.int(lineWidth)) - padding;
				}
				else	// LEFT
				{
					ox += padding;
				}
				
				switch (borderStyle)
				{
					case SHADOW:
						for (iterY in 0...iterationsY)
						{
							for (iterX in 0...iterationsX)
							{
								blitLine(line, borderGlyphs, ox + deltaX * (iterX + 1), oy + deltaY * (iterY + 1));
							}
						}
					case OUTLINE:
						//Render an outline around the text
						//(do 8 offset draw calls)
						var itd:Int = 0;
						for (iter in 0...iterations)
						{
							itd = delta * (iter + 1);
							//upper-left
							blitLine(line, borderGlyphs, ox - itd, oy - itd);
							//upper-middle
							blitLine(line, borderGlyphs, ox, oy - itd);
							//upper-right
							blitLine(line, borderGlyphs, ox + itd, oy - itd);
							//middle-left
							blitLine(line, borderGlyphs, ox - itd, oy);
							//middle-right
							blitLine(line, borderGlyphs, ox + itd, oy);
							//lower-left
							blitLine(line, borderGlyphs, ox - itd, oy + itd);
							//lower-middle
							blitLine(line, borderGlyphs, ox, oy + itd);
							//lower-right
							blitLine(line, borderGlyphs, ox + itd, oy + itd);
						}
					case NONE:
				}
			}
			
			// render text
			for (i in 0...numLines)
			{
				line = _lines[i];
				lineWidth = _linesWidth[i];
				
				// LEFT
				ox = Std.int(Math.abs(font.minOffsetX) * size);
				oy = Std.int(i * (font.lineHeight * size + lineSpacing)) + padding;
				
				if (alignment == GBitmapTextAlign.CENTER) 
				{
					ox += Std.int((_fieldWidth - lineWidth) * 0.5) - padding;
				}
				if (alignment == GBitmapTextAlign.RIGHT) 
				{
					ox += (_fieldWidth - Std.int(lineWidth)) - padding;
				}
				else	// LEFT
				{
					ox += padding;
				}
				
				blitLine(line, textGlyphs, ox, oy);
			}
			
			_bitmapData.unlock();
		}
		
		_pendingGraphicChange = false;
	}
	
	private function blitLine(line:String, glyphs:GBitmapGlyphCollection, startX:Int, startY:Int):Void
	{
		if (glyphs == null) return;
		
		var glyph:GBitmapGlyph;
		var charCode:Int;
		var curX:Int = startX;
		var curY:Int = startY;
		
		var spaceWidth:Int = Std.int(font.spaceWidth * size);
		var tabWidth:Int = Std.int(spaceWidth * numSpacesInTab);
		
		var lineLength:Int = Utf8.length(line);
		
		for (i in 0...lineLength)
		{
			charCode = Utf8.charCodeAt(line, i);
			
			if (charCode == GBitmapFont.spaceCode)
			{
				curX += spaceWidth;
			}
			else if (charCode == GBitmapFont.tabCode)
			{
				curX += tabWidth;
			}
			else
			{
				glyph = glyphs.glyphMap.get(charCode);
				if (glyph != null)
				{
					_point.x = curX + glyph.offsetX;
					_point.y = curY + glyph.offsetY;
					_bitmapData.copyPixels(glyph.bitmap, glyph.rect, _point, null, null, true);
					curX += glyph.xAdvance;
				}				
			}
			
			curX += letterSpacing;
		}
	}
	
	/**
	 * Set border's style (shadow, outline, etc), color, and size all in one go!
	 * 
	 * @param	Style outline style
	 * @param	Color outline color in flash 0xAARRGGBB format
	 * @param	Size outline size in pixels
	 * @param	Quality outline quality - # of iterations to use when drawing. 0:just 1, 1:equal number to BorderSize
	 */
	public inline function setBorderStyle(Style:GBitmapTextBorderStyle, Color:UInt = 0xFFFFFFFF, Size:Float = 1, Quality:Float = 1):Void 
	{
		borderStyle = Style;
		borderColor = Color;
		borderSize = Size;
		borderQuality = Quality;
		if (borderStyle == GBitmapTextBorderStyle.SHADOW)
		{
			shadowOffset.setTo(borderSize, borderSize);
		}
		_pendingGraphicChange = true;
		checkImmediateChanges();
	}
	
	/**
	 * Sets the width of the text field. If the text does not fit, it will spread on multiple lines.
	 */
	function set_width(value:Float):Float
	{
		value = Std.int(value);
		value = Math.max(1, value);
		
		if (value != width)
		{
			_fieldWidth = (value == 0) ? 1 : Std.int(value);
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		return value;
	}
	
	private function set_alignment(value:GBitmapTextAlign):GBitmapTextAlign 
	{
		if (alignment != value)
		{
			alignment = value;
			_pendingGraphicChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_multiLine(value:Bool):Bool 
	{
		if (multiLine != value)
		{
			multiLine = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_font(value:GBitmapFont):GBitmapFont 
	{
		if (font != value && value != null)
		{
			font = value;
			_pendingTextChange = true;
			_pendingBorderGlyphsChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_lineSpacing(value:Int):Int
	{
		if (lineSpacing != value)
		{
			lineSpacing = Std.int(Math.abs(value));
			_pendingGraphicChange = true;
			checkImmediateChanges();
		}
		
		return lineSpacing;
	}
	
	private function set_letterSpacing(value:Int):Int
	{
		var tmp:Int = Std.int(Math.abs(value));
		
		if (tmp != letterSpacing)
		{
			letterSpacing = tmp;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return letterSpacing;
	}
	
	private function set_autoUpperCase(value:Bool):Bool 
	{
		if (autoUpperCase != value)
		{
			autoUpperCase = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return autoUpperCase;
	}
	
	private function set_wordWrap(value:Bool):Bool 
	{
		if (wordWrap != value)
		{
			wordWrap = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return wordWrap;
	}
	
	private function set_wrapByWord(value:Bool):Bool
	{
		if (wrapByWord != value)
		{
			wrapByWord = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_autoSize(value:Bool):Bool 
	{
		if (autoSize != value)
		{
			autoSize = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return autoSize;
	}
	
	private function set_size(value:Float):Float
	{
		var tmp:Float = Math.abs(value);
		
		if (tmp != size)
		{
			size = tmp;
			_pendingTextGlyphsChange = true;
			_pendingBorderGlyphsChange = true;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_padding(value:Int):Int
	{
		if (value != padding)
		{
			padding = value;
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_numSpacesInTab(value:Int):Int 
	{
		if (numSpacesInTab != value && value > 0)
		{
			numSpacesInTab = value;
			_tabSpaces = "";
			
			for (i in 0...value)
			{
				_tabSpaces += " ";
			}
			
			_pendingTextChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_background(value:Bool):Bool
	{
		if (background != value)
		{
			background = value;
			_pendingGraphicChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_backgroundColor(value:UInt):UInt 
	{
		if (backgroundColor != value)
		{
			backgroundColor = value;
			_pendingGraphicChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_borderStyle(style:GBitmapTextBorderStyle):GBitmapTextBorderStyle
	{		
		if (style != borderStyle)
		{
			borderStyle = style;
			_pendingBorderGlyphsChange = true;
			checkImmediateChanges();
		}
		
		return borderStyle;
	}
	
	private function set_borderColor(value:UInt):UInt 
	{
		if (borderColor != value)
		{
			borderColor = value;
			_pendingBorderGlyphsChange = true;
			checkImmediateChanges();
		}
		
		return value;
	}
	
	private function set_borderSize(value:Float):Float
	{
		if (value != borderSize)
		{			
			borderSize = value;
			
			if (borderStyle != GBitmapTextBorderStyle.NONE)
			{
				_pendingGraphicChange = true;
				checkImmediateChanges();
			}
		}
		
		return value;
	}
	
	private function set_borderQuality(value:Float):Float
	{
		value = Math.min(1, Math.max(0, value));
		
		if (value != borderQuality)
		{
			borderQuality = value;
			
			if (borderStyle != GBitmapTextBorderStyle.NONE)
			{
				_pendingGraphicChange = true;
				checkImmediateChanges();
			}
		}
		
		return value;
	}
	
	private function get_numLines():Int
	{
		return _lines.length;
	}
	
	/**
	 * Calculates maximum width of the text.
	 * 
	 * @return	text width.
	 */
	private function get_textWidth():Float
	{
		var max:Float = 0;
		var numLines:Int = _lines.length;
		var lineWidth:Float;
		_linesWidth = [];
		
		for (i in 0...numLines)
		{
			lineWidth = getLineWidth(i);
			_linesWidth[i] = lineWidth;
			max = Math.max(max, lineWidth);
		}
		
		return max;
	}
	
	private function get_textHeight():Float
	{
		return (lineHeight + lineSpacing) * _lines.length - lineSpacing;
	}
	
	private function get_lineHeight():Float
	{
		return font.lineHeight * size;
	}
	
	private function set_updateImmediately(value:Bool):Bool
	{
		if (updateImmediately != value)
		{
			updateImmediately = value;
			if (value)
			{
				checkPendingChanges();
			}
		}
		
		return value;
	}
	
	private function set_smoothing(value:Bool):Bool
	{
		_bitmap.smoothing = value;
		
		return smoothing = value;
	}
	
	private function updateTextGlyphs():Void
	{
		if (font == null)	return;
		
		if (textGlyphs != null)
		{
			textGlyphs.dispose();
		}
		textGlyphs = font.prepareGlyphs(size, textColor, useTextColor, smoothing);
		
		_pendingTextGlyphsChange = false;
		_pendingGraphicChange = true;
	}
	
	private function updateBorderGlyphs():Void
	{
		if (font != null && (borderGlyphs == null || borderColor != borderGlyphs.color || size != borderGlyphs.scale || font != borderGlyphs.font))
		{
			if (borderGlyphs != null)
			{
				borderGlyphs.dispose();
			}
			borderGlyphs = font.prepareGlyphs(size, borderColor, true, smoothing);
		}
		
		_pendingBorderGlyphsChange = false;
		_pendingGraphicChange = true;
	}
}

/**
 * Holds information and bitmap glyphs for a bitmap font.
 */
class GBitmapFont
{
	public static inline var spaceCode:Int = 32;
	public static inline var tabCode:Int = 9;
	public static inline var newLineCode:Int = 10;
	
	public static inline var defaultFontKey:String = "defaultFontKey";
	
	private static inline var defaultFontData:String = " 36000000000000000000!26101010001000\"46101010100000000000000000#66010100111110010100111110010100000000$56001000111011000001101110000100%66100100000100001000010000010010000000&66011000100000011010100100011010000000'26101000000000(36010100100100010000)36100010010010100000*46000010100100101000000000+46000001001110010000000000,36000000000000010100-46000000001110000000000000.26000000001000/66000010000100001000010000100000000000056011001001010010100100110000000156011000010000100001000010000000256111000001001100100001111000000356111000001001100000101110000000456100101001010010011100001000000556111101000011100000101110000000656011001000011100100100110000000756111000001000010001100001000000856011001001001100100100110000000956011001001010010011100001000000:26001000100000;26001000101000<46001001001000010000100000=46000011100000111000000000>46100001000010010010000000?56111000001001100000000100000000@66011100100010101110101010011100000000A56011001001010010111101001000000B56111001001011100100101110000000C56011001001010000100100110000000D56111001001010010100101110000000E56111101000011000100001111000000F56111101000010000110001000000000G56011001000010110100100111000000H56100101001011110100101001000000I26101010101000J56000100001000010100100110000000K56100101001010010111001001000000L46100010001000100011100000M66100010100010110110101010100010000000N56100101001011010101101001000000O56011001001010010100100110000000P56111001001010010111001000000000Q56011001001010010100100110000010R56111001001010010111001001000000S56011101000001100000101110000000T46111001000100010001000000U56100101001010010100100110000000V56100101001010010101000100000000W66100010100010101010110110100010000000X56100101001001100100101001000000Y56100101001010010011100001001100Z56111100001001100100001111000000[36110100100100110000}46110001000010010011000000]36110010010010110000^46010010100000000000000000_46000000000000000011110000'26101000000000a56000000111010010100100111000000b56100001110010010100101110000000c46000001101000100001100000d56000100111010010100100111000000e56000000110010110110000110000000f46011010001000110010000000g5700000011001001010010011100001001100h56100001110010010100101001000000i26100010101000j37010000010010010010100k56100001001010010111001001000000l26101010101000m66000000111100101010101010101010000000n56000001110010010100101001000000o56000000110010010100100110000000p5700000111001001010010111001000010000q5700000011101001010010011100001000010r46000010101100100010000000s56000000111011000001101110000000t46100011001000100001100000u56000001001010010100100111000000v56000001001010010101000100000000w66000000101010101010101010011110000000x56000001001010010011001001000000y5700000100101001010010011100001001100z56000001111000100010001111000000{46011001001000010001100000|26101010101000}46110001000010010011000000~56010101010000000000000000000000\\46111010101010101011100000";
	
	private static var fonts:Map<String, GBitmapFont> = new Map<String, GBitmapFont>();
	
	/**
	 * Stores a font for global use using an identifier.
	 * @param	fontKey		String identifer for the font.
	 * @param	font		Font to store.
	 */
	public static function store(fontKey:String, font:GBitmapFont):Void 
	{
		if (!fonts.exists(fontKey))
		{
			fonts.set(fontKey, font);
		}
	}
	
	/**
	 * Retrieves a font previously stored.
	 * @param	fontKey		Identifier of font to fetch.
	 * @return	Stored font, or null if no font was found.
	 */
	public static function get(fontKey:String):GBitmapFont 
	{
		return fonts.get(fontKey);
	}
	
	/**
	 * Removes font with provided fontKey and disposes it.
	 * @param	fontKey		The name of font to remove.
	 */
	public static function remove(fontKey):Void
	{
		var font:GBitmapFont = fonts.get(fontKey);
		fonts.remove(fontKey);
		
		if (font != null)
		{
			font.dispose();
		}
	}
	
	/**
	 * Clears fonts storage and disposes all fonts.
	 */
	public static function clearFonts():Void
	{
		for (font in fonts)
		{
			font.dispose();
		}
		
		fonts = new Map<String, GBitmapFont>();
	}
	
	/**
	 * Retrieves default GBitmapFont.
	 */
	public static function getDefaultFont():GBitmapFont
	{
		var font:GBitmapFont = GBitmapFont.get(defaultFontKey);
		
		if (font != null)
		{
			return font;
		}
		
		var letters:String = "";
		var bd:BitmapData = new BitmapData(700, 9, true, 0xFF888888);
		
		var letterPos:Int = 0;
		var i:Int = 0;
		
		while (i < defaultFontData.length) 
		{
			letters += defaultFontData.substr(i, 1);
			
			var gw:Int = Std.parseInt(defaultFontData.substr(++i, 1));
			var gh:Int = Std.parseInt(defaultFontData.substr(++i, 1));
			
			for (py in 0...gh) 
			{
				for (px in 0...gw) 
				{
					i++;
					
					if (defaultFontData.substr(i, 1) == "1") 
					{
						bd.setPixel32(1 + letterPos * 7 + px, 1 + py, 0xFFFFFFFF);
					}
					else 
					{
						bd.setPixel32(1 + letterPos * 7 + px, 1 + py, 0x00000000);
					}
				}
			}
			
			i++;
			letterPos++;
		}
		
		return GBitmapFont.fromXNA(defaultFontKey, bd, letters);
	}
	
	/**
	 * Default letters for XNA font.
	 */
	public static inline var DEFAULT_GLYPHS:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
	
	private static var POINT:Point = new Point();
	
	private static var MATRIX:Matrix = new Matrix();
	
	private static var COLOR_TRANSFORM:ColorTransform = new ColorTransform();
	
	/**
	 * The size of the font. Can be useful for AngelCode fonts.
	 */
	public var size(default, null):Int = 0;
	
	public var lineHeight(default, null):Int = 0;
	
	public var bold:Bool = false;
	
	public var italic:Bool = false;
	
	public var fontName:String;
	
	/**
	 * Minimum x offset in this font. 
	 * This is a helper varible for rendering purposes.
	 */
	public var minOffsetX:Int = 0;
	
	/**
	 * The width of space character.
	 */
	public var spaceWidth:Int = 0;
	
	/**
	 * Source image for this font.
	 */
	public var bitmap:BitmapData;
	
	public var glyphs:Map<Int, GBitmapGlyphFrame>;
	
	/**
	 * Creates and stores new bitmap font using specified source image.
	 */
	public function new(name:String, bitmap:BitmapData)
	{
		this.bitmap = bitmap;
		this.fontName = name;
		glyphs = new Map<Int, GBitmapGlyphFrame>();
		GBitmapFont.store(name, this);
	}
	
	/**
	 * Destroys this font object.
	 * WARNING: it disposes source image also.
	 */
	public function dispose():Void 
	{
		if (bitmap != null)
		{
			bitmap.dispose();
		}
		
		bitmap = null;
		glyphs = null;
		fontName = null;
	}
	
	/**
	 * Loads font data in AngelCode's format.
	 * 
	 * @param	Source		Font image source.
	 * @param	Data		XML font data.
	 * @return	Generated bitmap font object.
	 */
	public static function fromAngelCode(Source:BitmapData, Data:Xml):GBitmapFont
	{
		var fast:Fast = new Fast(Data.firstElement());
		var fontName:String = Std.string(fast.node.info.att.face);
		
		var font:GBitmapFont = GBitmapFont.get(fontName);
		
		if (font != null)
		{
			return font;
		}
		
		font = new GBitmapFont(fontName, Source);
		font.lineHeight = Std.parseInt(fast.node.common.att.lineHeight);
		font.size = Std.parseInt(fast.node.info.att.size);
		font.fontName = Std.string(fast.node.info.att.face);
		font.bold = (Std.parseInt(fast.node.info.att.bold) != 0);
		font.italic = (Std.parseInt(fast.node.info.att.italic) != 0);
		
		var frame:Rectangle;
		var glyph:String;
		var charCode:Int;
		var spaceCharCode:Int = " ".charCodeAt(0);
		var xOffset:Int, yOffset:Int, xAdvance:Int;
		var frameHeight:Int;
		
		var chars = fast.node.chars;
		
		for (char in chars.nodes.char)
		{
			frame = new Rectangle();
			frame.x = Std.parseInt(char.att.x);
			frame.y = Std.parseInt(char.att.y);
			frame.width = Std.parseInt(char.att.width);
			frameHeight = Std.parseInt(char.att.height);
			frame.height = frameHeight;
			
			xOffset = char.has.xoffset ? Std.parseInt(char.att.xoffset) : 0;
			yOffset = char.has.yoffset ? Std.parseInt(char.att.yoffset) : 0;
			xAdvance = char.has.xadvance ? Std.parseInt(char.att.xadvance) : 0;
			
			font.minOffsetX = (font.minOffsetX > xOffset) ? xOffset : font.minOffsetX;
			
			glyph = null;
			charCode = -1;
			
			if (char.has.letter)
			{
				glyph = char.att.letter;
			}
			else if (char.has.id)
			{
				charCode = Std.parseInt(char.att.id);
			}
			
			if (charCode == -1 && glyph == null) 
			{
				throw 'Invalid font xml data!';
			}
			
			if (glyph != null)
			{
				glyph = switch(glyph) 
				{
					case "space": ' ';
					case "&quot;": '"';
					case "&amp;": '&';
					case "&gt;": '>';
					case "&lt;": '<';
					default: glyph;
				}
				
				charCode = Utf8.charCodeAt(glyph, 0);
			}
			
			font.addGlyphFrame(charCode, frame, xOffset, yOffset, xAdvance);
			
			if (charCode == spaceCharCode)
			{
				font.spaceWidth = xAdvance;
			}
			else
			{
				font.lineHeight = (font.lineHeight > frameHeight + yOffset) ? font.lineHeight : frameHeight + yOffset;
			}
		}
		
		return font;
	}
	
	/**
	 * Load bitmap font in XNA/Pixelizer format. 
	 * I took this method from HaxePunk engine.
	 * 
	 * @param	key				Name for this font.
	 * @param	source			Source image for this font.
	 * @param	letters			String of glyphs contained in the source image, in order (ex. " abcdefghijklmnopqrstuvwxyz"). Defaults to DEFAULT_GLYPHS.
	 * @param	glyphBGColor	An additional background color to remove. Defaults to 0xFF202020, often used for glyphs background.
	 * @return	Generated bitmap font object.
	 */
	public static function fromXNA(key:String, source:BitmapData, letters:String = null, glyphBGColor:Int = 0x00000000):GBitmapFont
	{
		var font:GBitmapFont = GBitmapFont.get(key);
		
		if (font != null)
		{
			return font;
		}
		
		font = new GBitmapFont(key, source);
		font.fontName = key;
		
		letters = (letters == null) ? DEFAULT_GLYPHS : letters;
		
		var bmd:BitmapData = source;
		var globalBGColor:Int = bmd.getPixel(0, 0);
		var cy:Int = 0;
		var cx:Int;
		var letterIdx:Int = 0;
		var charCode:Int;
		var numLetters:Int = Utf8.length(letters);
		var rect:Rectangle;
		var xAdvance:Int;
		
		while (cy < bmd.height && letterIdx < numLetters)
		{
			var rowHeight:Int = 0;
			cx = 0;
			
			while (cx < bmd.width && letterIdx < numLetters)
			{
				if (Std.int(bmd.getPixel(cx, cy)) != globalBGColor) 
				{
					// found non bg pixel
					var gx:Int = cx;
					var gy:Int = cy;
					
					// find width and height of glyph
					while (Std.int(bmd.getPixel(gx, cy)) != globalBGColor) gx++;
					while (Std.int(bmd.getPixel(cx, gy)) != globalBGColor) gy++;
					
					var gw:Int = gx - cx;
					var gh:Int = gy - cy;
					
					charCode = Utf8.charCodeAt(letters, letterIdx);
					
					rect = new Rectangle(cx, cy, gw, gh);
					
					xAdvance = gw;
					
					font.addGlyphFrame(charCode, rect, 0, 0, xAdvance);
					
					if (charCode == spaceCode)
					{
						font.spaceWidth = xAdvance;
					}
					
					// store max size
					if (gh > rowHeight) rowHeight = gh;
					if (gh > font.size) font.size = gh;
					
					// go to next glyph
					cx += gw;
					letterIdx++;
				}
				
				cx++;
			}
			
			// next row
			cy += (rowHeight + 1);
		}
		
		font.lineHeight = font.size;
		
		// remove background color
		POINT.x = POINT.y = 0;
		var bgColor32:Int = bmd.getPixel32(0, 0);
		#if !js
		bmd.threshold(bmd, bmd.rect, POINT, "==", bgColor32, 0x00000000, 0xFFFFFFFF, true);
		#else
		replaceColor(bmd, bgColor32, 0x00000000);
		#end
		if (glyphBGColor != 0x00000000)
		{
			#if !js
			bmd.threshold(bmd, bmd.rect, POINT, "==", glyphBGColor, 0x00000000, 0xFFFFFFFF, true);
			#else
			replaceColor(bmd, glyphBGColor, 0x00000000);
			#end
		}
		
		return font;
	}
	
	public static function replaceColor(bitmapData:BitmapData, color:Int, newColor:Int):BitmapData
	{
		var row:Int = 0;
		var column:Int = 0;
		var rows:Int = bitmapData.height;
		var columns:Int = bitmapData.width;
		bitmapData.lock();
		while (row < rows)
		{
			column = 0;
			while (column < columns)
			{
				if (bitmapData.getPixel32(column, row) == cast color)
				{
					bitmapData.setPixel32(column, row, newColor);
				}
				column++;
			}
			row++;
		}
		bitmapData.unlock();
		
		return bitmapData;
	}
	
	/**
	 * Loads monospace bitmap font.
	 * 
	 * @param	key			Name for this font.
	 * @param	source		Source image for this font.
	 * @param	letters		The characters used in the font set, in display order. You can use the TEXT_SET consts for common font set arrangements.
	 * @param	charSize	The size of each character in the font set.
	 * @param	region		The region of image to use for the font. Default is null which means that the whole image will be used.
	 * @param	spacing		Spaces between characters in the font set. Default is null which means no spaces.
	 * @return	Generated bitmap font object.
	 */
	public static function fromMonospace(key:String, source:BitmapData, letters:String = null, charSize:Point, region:Rectangle = null, spacing:Point = null):GBitmapFont
	{
		var font:GBitmapFont = GBitmapFont.get(key);
		if (font != null)
			return font;
		
		letters = (letters == null) ? DEFAULT_GLYPHS : letters;
		
		region = (region == null) ? source.rect : region;
		
		if (region.width == 0 || region.right > source.width)
		{
			region.width = source.width - region.x;
		}
		
		if (region.height == 0 || region.bottom > source.height)
		{
			region.height = source.height - region.y;
		}
		
		spacing = (spacing == null) ? new Point(0, 0) : spacing;
		
		var bitmapWidth:Int = Std.int(region.width);
		var bitmapHeight:Int = Std.int(region.height);
		
		var startX:Int = Std.int(region.x);
		var startY:Int = Std.int(region.y);
		
		var xSpacing:Int = Std.int(spacing.x);
		var ySpacing:Int = Std.int(spacing.y);
		
		var charWidth:Int = Std.int(charSize.x);
		var charHeight:Int = Std.int(charSize.y);
		
		var spacedWidth:Int = charWidth + xSpacing;
		var spacedHeight:Int = charHeight + ySpacing;
		
		var numRows:Int = (charHeight == 0) ? 1 : Std.int((bitmapHeight + ySpacing) / spacedHeight);
		var numCols:Int = (charWidth == 0) ? 1 : Std.int((bitmapWidth + xSpacing) / spacedWidth);
		
		font = new GBitmapFont(key, source);
		font.fontName = key;
		font.lineHeight = font.size = charHeight;
		
		var charRect:Rectangle;
		var xAdvance:Int = charWidth;
		font.spaceWidth = xAdvance;
		var letterIndex:Int = 0;
		var numLetters:Int = letters.length;
		
		for (j in 0...(numRows))
		{
			for (i in 0...(numCols))
			{
				charRect = new Rectangle(startX + i * spacedWidth, startY + j * spacedHeight, charWidth, charHeight);
				font.addGlyphFrame(Utf8.charCodeAt(letters, letterIndex), charRect, 0, 0, xAdvance);
				
				letterIndex++;
				
				if (letterIndex >= numLetters)
				{
					return font;
				}
			}
		}
		
		return font;
	}
	
	/**
	 * Internal method which creates and add glyph frames into this font.
	 * 
	 * @param	charCode		Char code for glyph frame.
	 * @param	frame			Glyph area from source image.
	 * @param	offsetX			X offset before rendering this glyph.
	 * @param	offsetX			Y offset before rendering this glyph.
	 * @param	xAdvance		How much cursor will jump after this glyph.
	 */
	private function addGlyphFrame(charCode:Int, frame:Rectangle, offsetX:Int = 0, offsetY:Int = 0, xAdvance:Int = 0):Void
	{
		if (frame.width == 0 || frame.height == 0 || glyphs.get(charCode) != null)	return;
		
		var glyphFrame:GBitmapGlyphFrame = new GBitmapGlyphFrame(this);
		glyphFrame.charCode = charCode;
		glyphFrame.xoffset = offsetX;
		glyphFrame.yoffset = offsetY;
		glyphFrame.xadvance = xAdvance;
		glyphFrame.rect = frame;
		glyphs.set(charCode, glyphFrame);
	}
	
	/**
	 * Generates special collection of GBitmapGlyph objects, which are used in RENDER_BLIT mode.
	 * These GBitmapGlyph objects contain prepared (scales and color transformed) glyph images, which saves some CPU cycles for you.
	 * 
	 * @param	scale		How much scale apply to glyphs.
	 * @param	color		color in AARRGGBB format for glyph preparations.
	 * @param	useColor	Whether to use color transformation for glyphs.
	 * @return	Generated collection of GBitmapGlyph objects. They are used for rendering text and borders in RENDER_BLIT mode.
	 */
	public function prepareGlyphs(scale:Float, color:UInt, useColor:Bool = true, smoothing:Bool = true):GBitmapGlyphCollection
	{
		return new GBitmapGlyphCollection(this, scale, color, useColor, smoothing);
	}
}

/**
 * Helper object. Stores info about single glyph (without transformations).
 */
class GBitmapGlyphFrame 
{
	/**
	 * Bitmap font which this glyph frame belongs to.
	 */
	public var parent:GBitmapFont;
	
	public var charCode:Int;
	
	/**
	 * x offset to draw symbol with
	 */
	public var xoffset:Int;
	
	/**
	 * y offset to draw symbol with
	 */
	public var yoffset:Int;
	
	/**
	 * real width of symbol
	 */
	public var xadvance:Int;
	
	/**
	 * Source image area which contains image of this glyph
	 */
	public var rect:Rectangle;
	
	/**
	 * Trimmed image of this glyph
	 */
	public var bitmap(get, null):BitmapData;
	
	private var _bitmap:BitmapData;
	
	/**
	 * tile id in parent's tileSheet
	 */
	public var tileID:Int;
	
	public function new(parent:GBitmapFont)
	{ 
		this.parent = parent;
	}
	
	public function dispose():Void
	{
		rect = null;
		
		if (_bitmap != null)
		{
			_bitmap.dispose();
		}
		
		_bitmap = null;
	}
	
	public function get_bitmap():BitmapData
	{
		if (_bitmap != null)
		{
			return _bitmap;
		}
		
		_bitmap = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x00000000);
		_bitmap.copyPixels(parent.bitmap, rect, new Point());
		return _bitmap;
	}
}

/**
 * Helper class for blit render mode to reduce BitmapData draw() method calls.
 * It stores info about transformed (scale and color transformed) bitmap font glyphs. 
 */
class GBitmapGlyphCollection
{
	public var minOffsetX:Float = 0;
	
	public var glyphMap:Map<Int, GBitmapGlyph>;
	
	public var glyphs:Array<GBitmapGlyph>;
	
	public var color:UInt;
	
	public var scale:Float;
	
	public var spaceWidth:Float = 0;
	
	public var font:GBitmapFont;
	
	public function new(font:GBitmapFont, scale:Float, color:UInt, useColor:Bool = true, smoothing:Bool = true)
	{
		glyphMap = new Map<Int, GBitmapGlyph>();
		glyphs = new Array<GBitmapGlyph>();
		this.font = font;
		this.scale = scale;
		this.color = (useColor) ? color : 0xFFFFFFFF;
		this.minOffsetX = font.minOffsetX * scale;
		prepareGlyphs(smoothing);
	}
	
	private function prepareGlyphs(smoothing:Bool = true):Void
	{
		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);
		
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.redMultiplier = ((color >> 16) & 0xFF) / 255;
		colorTransform.greenMultiplier = ((color >> 8) & 0xFF) / 255;
		colorTransform.blueMultiplier = (color & 0xFF) / 255;
		colorTransform.alphaMultiplier = ((color >> 24) & 0xFF) / 255;
		
		var glyphBD:BitmapData;
		var preparedBD:BitmapData;
		var glyph:GBitmapGlyphFrame;
		var preparedGlyph:GBitmapGlyph;
		var bdWidth:Int, bdHeight:Int;
		var offsetX:Int, offsetY:Int, xAdvance:Int;
		
		spaceWidth = font.spaceWidth * scale;
		
		for (glyph in font.glyphs)
		{
			glyphBD = glyph.bitmap;
			
			bdWidth = Math.ceil(glyphBD.width * scale);
			bdHeight = Math.ceil(glyphBD.height * scale);
			
			bdWidth = (bdWidth > 0) ? bdWidth : 1;
			bdHeight = (bdHeight > 0) ? bdHeight : 1;
			
			preparedBD = new BitmapData(bdWidth, bdHeight, true, 0x00000000);
			
			#if !js
			preparedBD.draw(glyphBD, matrix, colorTransform, null, null, smoothing);
			#else
			preparedBD.draw(glyphBD, matrix, null, null, null, smoothing);
			preparedBD.colorTransform(preparedBD.rect, colorTransform);
			#end
			
			offsetX = Math.ceil(glyph.xoffset * scale);
			offsetY = Math.ceil(glyph.yoffset * scale);
			xAdvance = Math.ceil(glyph.xadvance * scale);
			
			preparedGlyph = new GBitmapGlyph(glyph.charCode, preparedBD, offsetX, offsetY, xAdvance);
			
			glyphs.push(preparedGlyph);
			glyphMap.set(preparedGlyph.charCode, preparedGlyph);
		}
	}
	
	public function dispose():Void
	{
		if (glyphs != null)
		{
			for (glyph in glyphs)
			{
				glyph.dispose();
			}
		}
		
		glyphs = null;
		glyphMap = null;
		font = null;
	}
}

/**
 * Helper class for blit render mode. 
 * Stores info about single transformed bitmap glyph.
 */
class GBitmapGlyph
{
	public var charCode:Int;
	
	public var bitmap:BitmapData;
	
	public var offsetX:Int = 0;
	
	public var offsetY:Int = 0;
	
	public var xAdvance:Int = 0;
	
	public var rect:Rectangle;
	
	public function new(charCode:Int, bmd:BitmapData, offsetX:Int = 0, offsetY:Int = 0, xAdvance:Int = 0)
	{
		this.charCode = charCode;
		this.bitmap = bmd;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.xAdvance = xAdvance;
		this.rect = bmd.rect;
	}
	
	public function dispose():Void
	{
		if (bitmap != null)
		{
			bitmap.dispose();
		}
		
		bitmap = null;
	}
}