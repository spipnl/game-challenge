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
	private var _leftTitle:FlxText;
	private var _rightTitle:FlxText;
	
	@:isVar public var leftTitle(get, set):String;
	@:isVar public var rightTitle(get, set):String;
	
	public function new() 
	{
		super();
		
		_background = new FlxSprite(0, 0);
		_background.makeGraphic(FlxG.width, _topMenuHeight, 0xFF2980b9);
		_background.alpha = 0.7;
		
		var titleWidth = 300;
		
		_leftTitle = new FlxText(10, 6, titleWidth);
		_leftTitle.font = "assets/fonts/OpenSans-Bold.ttf";
		_leftTitle.alignment = "left";
		_leftTitle.color = 0xecf0f1;
		_leftTitle.size = 16;
		
		_rightTitle = new FlxText(FlxG.width - titleWidth - 10, 6, titleWidth);
		_rightTitle.font = "assets/fonts/OpenSans-Bold.ttf";
		_rightTitle.alignment = "right";
		_rightTitle.color = 0xecf0f1;
		_rightTitle.size = 16;
		
		add(_background);
		add(_leftTitle);
		add(_rightTitle);
	}
	
	public function get_leftTitle():String
	{
		return leftTitle;
	}
	
	public function set_leftTitle(Title:String):String
	{
		leftTitle = Title;
		_leftTitle.text = Title;
		
		return leftTitle;
	}
	
	public function get_rightTitle():String
	{
		return rightTitle;
	}
	
	public function set_rightTitle(Title:String):String
	{
		rightTitle = Title;
		_rightTitle.text = Title;
		
		return rightTitle;
	}
}
