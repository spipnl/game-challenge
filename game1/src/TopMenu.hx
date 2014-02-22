package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class TopMenu extends FlxGroup
{
	private var _topMenuHeight:Int = 20;
	
	private var _background:FlxSprite;
	private var _title:FlxText;
	
	public function new() 
	{
		super();
		
		_background = new FlxSprite(0, 0);
		_background.makeGraphic(FlxG.width, _topMenuHeight, 0xFFBDC3C7);
		
		_title = new FlxText(2, 4, 100, "spipnl game1");
		_title.color = 0x2C3E50;
		
		add(_background);
		add(_title);
	}
}