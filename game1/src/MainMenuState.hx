package; 

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
	private var _topMenu:TopMenu;
	
	private var _buttons:FlxSpriteGroup;
	private var _buttonsBG:FlxSprite;
	private var _startButton:MenuButton;
	private var _aboutButton:FlxButton;
	
	private var _buttonsContainerWidth:Int = 120;
	private var _buttonsContainerHeight:Int = 72;
	
	private var _buttonWidth:Int = 100;
	private var _buttonHeight:Int = 22;
	
	override public function create():Void 
	{
		_topMenu = new TopMenu();
		
		//FlxG.debugger.visible = true;
		bgColor = 0xFF34495E;
		_buttons = new FlxSpriteGroup((FlxG.width - _buttonsContainerWidth) * 0.5,  (FlxG.height - _buttonsContainerHeight) * 0.5);
		_buttonsBG = new FlxSprite(0, 0);
		_buttonsBG.makeGraphic(_buttonsContainerWidth, _buttonsContainerHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(_buttonsBG, 0, 0, _buttonsBG.width, _buttonsBG.height, 4, 4, 0xFFECF0F1);
		
		_startButton = new MenuButton(10, 10, _buttonWidth, _buttonHeight, "Start", onStart);
		_aboutButton = new MenuButton(10, 40, _buttonWidth, _buttonHeight, "About", onAbout);
		
		/*
		var buttonSprite = new Sprite();
		buttonSprite.graphics.beginFill(0x3498DB);
		buttonSprite.graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, 10);
		buttonSprite.graphics.endFill();
		
		_aboutButton.pixels.draw(buttonSprite);
		*/
		_buttons.add(_buttonsBG);
		_buttons.add(_startButton);
		_buttons.add(_aboutButton);
		
		add(_buttons);
		
		add(_topMenu);
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	private function onStart():Void
	{
		trace("Start");
		FlxG.switchState(new PlayState());
	}
	
	private function onAbout():Void
	{
		trace("About");
	}
}