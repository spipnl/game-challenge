package; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import openfl.Assets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

/**
 * Initial MainMenu
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MainMenu extends FlxSpriteGroup
{
    private var _isStarted:Bool = false;
    
	private var _buttonsBG:FlxSprite;
    
	private var _startButton:MenuButton;
	private var _aboutButton:MenuButton;
	
	private var _buttonsContainerWidth:Int = 300;
	private var _buttonsContainerHeight:Int = 250;
	
	public function new()
	{
        super((FlxG.width - _buttonsContainerWidth) * 0.5,  300);
        
		_buttonsBG = new FlxSprite(0, 0);
		_buttonsBG.makeGraphic(_buttonsContainerWidth, _buttonsContainerHeight, FlxColor.TRANSPARENT);
		//FlxSpriteUtil.drawRoundRect(_buttonsBG, 0, 0, _buttonsBG.width, _buttonsBG.height, 8, 8, 0xFFFFFFFF);
        
		_startButton = new MenuButton("Start", onStart);
		_aboutButton = new MenuButton("About", onAbout);
        
        _startButton.x = (_buttonsContainerWidth - _startButton.width) * 0.5;
        _startButton.y = 30;
        
        _aboutButton.x = (_buttonsContainerWidth - _aboutButton.width) * 0.5;
        _aboutButton.y = _buttonsContainerHeight - _aboutButton.height - 30;
		
		add(_buttonsBG);
		add(_startButton);
		add(_aboutButton);
	}
	
    public function isStarted()
    {
        return _isStarted;
    }
    
	/**
	 * Create the default background
	 */
	private function createBackground():Void
	{
		var backgroundImage = Assets.getBitmapData("images/colored_desert.png");
		var bgImgWidth = backgroundImage.width;
		var bgImgHeight = backgroundImage.height;
		var bgX = (FlxG.width - bgImgWidth) * 0.5;
		var bgY = (FlxG.height - bgImgHeight) * 0.5;
		
		var backgroundSprite = new FlxSprite(bgX, bgY, backgroundImage);
		
		add(backgroundSprite);
	}
	
	private function onStart():Void
	{
        _isStarted = true;
	}
	
	private function onAbout():Void
	{
	}
}
