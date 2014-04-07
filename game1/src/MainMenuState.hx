package; 

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;
import flash.display.Sprite;

using flixel.util.FlxSpriteUtil;

/**
 * Initial MainMenu
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MainMenuState extends FlxState
{
	private var _topTitleBar:TitleBar;
	
	private var _buttons:FlxSpriteGroup;
	private var _buttonsBG:FlxSprite;
	private var _logo:FlxSprite;
	private var _startButton:MenuButton;
	private var _aboutButton:FlxButton;
	
	private var _buttonsContainerWidth:Int = 420;
	private var _buttonsContainerHeight:Int = 160;
	
	private var _buttonWidth:Int = 200;
	private var _buttonHeight:Int = 44;
	
	override public function create():Void 
	{
		FlxG.sound.playMusic("gameloop");
		createBackground();
		
		_topTitleBar = new TitleBar();
		_topTitleBar.leftTitle = "spipnl (mobile) development;";
		_topTitleBar.rightTitle = "Game 1 - Shoot the Targets!";
		
		bgColor = 0xFFbdc3c7;
		_buttons = new FlxSpriteGroup((FlxG.width - _buttonsContainerWidth) * 0.5,  (FlxG.height - _buttonsContainerHeight) * 0.5);
		_buttonsBG = new FlxSprite(0, 0);
		_buttonsBG.makeGraphic(_buttonsContainerWidth, _buttonsContainerHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(_buttonsBG, 80, 0, _buttonsBG.width - 80, _buttonsBG.height, 8, 8, 0xFFFFFFFF);
		
		var _logo:FlxSprite = new FlxSprite(0, 0);
		_logo.loadGraphic(Assets.getBitmapData("images/logo-menu.png"));
		
		_startButton = new MenuButton(_buttonsContainerWidth - _buttonWidth - 25, 25, _buttonWidth, _buttonHeight, "Start", onStart);
		_aboutButton = new MenuButton(_buttonsContainerWidth - _buttonWidth - 25, _buttonsContainerHeight - _buttonHeight - 25, _buttonWidth, _buttonHeight, "About", onAbout);
		
		_buttons.add(_buttonsBG);
		_buttons.add(_logo);
		_buttons.add(_startButton);
		_buttons.add(_aboutButton);
		
		add(_buttons);
		
		add(_topTitleBar);
	}
	
	private function createBackground():Void
	{
		// CREATE FLOOR TILES
		var	FloorImg:BitmapData = Assets.getBitmapData("images/fresh_snow.png");
		var ImgWidth = FloorImg.width;
		var ImgHeight = FloorImg.height;
		var i = 0; 
		var j = 0; 
		
		while ( i <= FlxG.width )  
		{
			while ( j <= FlxG.height )
			{
				var spr = new FlxSprite(i, j, FloorImg);
				add(spr);
				j += ImgHeight;
			}
			i += ImgWidth;
			j = 0;
		}
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	private function onStart():Void
	{
		FlxG.switchState(new PlayState(1));
	}
	
	private function onAbout():Void
	{
	}
}