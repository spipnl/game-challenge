package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class TopMenu extends FlxGroup
{
	private var _topMenuHeight:Int = 40;
	
	private var _background:FlxSprite;
	private var _title:FlxText;
	private var _gameTitle:FlxText;
	
	public function new() 
	{
		super();
		
		_background = new FlxSprite(0, 0);
		_background.makeGraphic(FlxG.width, _topMenuHeight, 0xFF2980b9);
		_background.alpha = 0.7;
		
		var titleWidth = 300;
		
		_title = new FlxText(10, 6, titleWidth, "spipnl (mobile) { development; }");
		_title.font = "assets/fonts/OpenSans-Bold.ttf";
		_title.alignment = "left";
		_title.color = 0xecf0f1;
		_title.size = 16;
		
		_gameTitle = new FlxText(FlxG.width - titleWidth - 10, 6, titleWidth, "game1");
		_gameTitle.font = "assets/fonts/OpenSans-Bold.ttf";
		_gameTitle.alignment = "right";
		_gameTitle.color = 0xecf0f1;
		_gameTitle.size = 16;
		
		add(_background);
		add(_title);
		add(_gameTitle);
	}
}