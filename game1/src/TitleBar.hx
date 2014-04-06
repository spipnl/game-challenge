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
class TitleBar extends FlxGroup
{
	public var background:FlxSprite;
	
	private var _topMenuHeight:Int = 16;
	
	private var _leftTitleText:FlxText;
	private var _middleTitleText:FlxText;
	private var _rightTitleText:FlxText;
	
	@:isVar public var leftTitle(get, set):String;
	@:isVar public var middleTitle(get, set):String;
	@:isVar public var rightTitle(get, set):String;
	
	public function new() 
	{
		super();
		
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, _topMenuHeight, 0xFF2980b9);
		background.alpha = 0.8;
		
		var titleWidth = 300;
		
		_leftTitleText = new FlxText(10, background.y - 3, titleWidth);
		_leftTitleText.font = "fonts/OpenSans-Bold.ttf";
		_leftTitleText.alignment = "left";
		_leftTitleText.color = 0xFFFFFF;
		_leftTitleText.size = 12;
		
		_middleTitleText = new FlxText((FlxG.width - titleWidth) * 0.5, background.y - 3, titleWidth);
		_middleTitleText.font = "fonts/OpenSans-Bold.ttf";
		_middleTitleText.alignment = "center";
		_middleTitleText.color = 0xFFFFFF;
		_middleTitleText.size = 12;
		
		_rightTitleText = new FlxText(FlxG.width - titleWidth - 10, background.y - 3, titleWidth);
		_rightTitleText.font = "fonts/OpenSans-Bold.ttf";
		_rightTitleText.alignment = "right";
		_rightTitleText.color = 0xFFFFFF;
		_rightTitleText.size = 12;
		
		add(background);
		add(_leftTitleText);
		add(_middleTitleText);
		add(_rightTitleText);
	}
	
	public function get_leftTitle():String
	{
		return leftTitle;
	}
	
	public function set_leftTitle(Title:String):String
	{
		leftTitle = Title;
		_leftTitleText.text = Title;
		
		return leftTitle;
	}
	
	public function get_middleTitle():String
	{
		return middleTitle;
	}
	
	public function set_middleTitle(Title:String):String
	{
		middleTitle = Title;
		_middleTitleText.text = Title;
		
		return middleTitle;
	}
	
	public function get_rightTitle():String
	{
		return rightTitle;
	}
	
	public function set_rightTitle(Title:String):String
	{
		rightTitle = Title;
		_rightTitleText.text = Title;
		
		return rightTitle;
	}
}
