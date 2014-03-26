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
	public var background:FlxSprite;
	
	private var _topMenuHeight:Int = 40;
	
	private var _leftTitleText:FlxText;
	private var _rightTitleText:FlxText;
	
	@:isVar public var leftTitle(get, set):String;
	@:isVar public var rightTitle(get, set):String;
	
	public function new() 
	{
		super();
		
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, _topMenuHeight, 0xFF2980b9);
		background.alpha = 0.6;
		
		var titleWidth = 300;
		
		_leftTitleText = new FlxText(10, 6, titleWidth);
		_leftTitleText.font = "fonts/OpenSans-Bold.ttf";
		_leftTitleText.alignment = "left";
		_leftTitleText.color = 0xecf0f1;
		_leftTitleText.size = 16;
		
		_rightTitleText = new FlxText(FlxG.width - titleWidth - 10, 6, titleWidth);
		_rightTitleText.font = "fonts/OpenSans-Bold.ttf";
		_rightTitleText.alignment = "right";
		_rightTitleText.color = 0xecf0f1;
		_rightTitleText.size = 16;
		
		add(background);
		add(_leftTitleText);
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
