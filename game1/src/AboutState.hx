package; 

import flash.display.BitmapData;
import flash.Lib;
import flash.net.URLRequest;
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
 * About state with description and credits
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class AboutState extends FlxState
{
	private var _topTitleBar:TitleBar;
	
	private var _aboutText:FlxText;
	
	private var _buttons:FlxSpriteGroup;
	private var _buttonsBG:FlxSprite;
	private var _logo:FlxSprite;
	private var _backButton:MenuButton;
	private var _githubButton:MenuButton;
	
	private var _buttonsContainerWidth:Int = 680;
	private var _buttonsContainerHeight:Int = 400;
	
	private var _buttonWidth:Int = 160;
	private var _buttonHeight:Int = 44;
	
	override public function create():Void 
	{
		createBackground();
		
		_topTitleBar = new TitleBar();
		_topTitleBar.leftTitle = "spipnl (mobile) development;";
		_topTitleBar.rightTitle = "Game 1 - Shoot the Targets!";
		
		bgColor = 0xFFbdc3c7;
		_buttons = new FlxSpriteGroup((FlxG.width - _buttonsContainerWidth) * 0.5,  (FlxG.height - _buttonsContainerHeight) * 0.5);
		_buttonsBG = new FlxSprite(0, 0);
		_buttonsBG.makeGraphic(_buttonsContainerWidth, _buttonsContainerHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(_buttonsBG, 0, 0, _buttonsBG.width, _buttonsBG.height, 8, 8, 0xFFFFFFFF);
		
		_backButton = new MenuButton(25, _buttonsContainerHeight - _buttonHeight - 25, _buttonWidth, _buttonHeight, "Back", onBack);
		
		_aboutText = new FlxText(20, 20, _buttonsContainerWidth - 40);
		_aboutText.font = "fonts/OpenSans-Bold.ttf";
		_aboutText.alignment = "left";
		_aboutText.color = 0xF576C75;
		_aboutText.size = 16;
		_aboutText.text = "You are a lonely cannon on a mission to save the world form the evil targets.\n\nUse mouse or touch controls to set up the power and radius of the bullets. Release when satisfied and watch your bullet destroy the targets. Bullets are limited to five per level, so use them wisely.\nOne bullet can destroy multiple targets and will vanish when it's velocity becomes zero or when it leaves the map.";
		_aboutText.text += "\n\nFor source and credits, visit the GitHub repository:";
		
		_githubButton = new MenuButton(_buttonsContainerWidth - _buttonWidth - 50, _buttonsContainerHeight - _buttonHeight - 172, _buttonWidth, _buttonHeight, "GitHub", onGithub);
		
		
		_buttons.add(_buttonsBG);
		_buttons.add(_aboutText);
		_buttons.add(_backButton);
		_buttons.add(_githubButton);
		
		add(_buttons);
		
		add(_topTitleBar);
	}
	
	/**
	 * Create the default background with a repeating image
	 */
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
	
	/**
	 * When the users clicks on the GitHub button, launch the browser with the github repo url
	 */
	private function onGithub():Void
	{
		Lib.getURL(new URLRequest("https://github.com/spipnl/game-challenge/tree/master/game1"));
	}
	
	/**
	 * When the users clicks on close, switch to main menu state
	 */
	private function onBack():Void
	{
		FlxG.switchState(new MainMenuState(false));
	}
}