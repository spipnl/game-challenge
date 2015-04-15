package; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import openfl.Assets;

/**
 * Initial MainMenu
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MainMenu extends FlxGroup
{
	private var _menuTitle:FlxSprite;
    private var _isStarted:Bool = false;
	
	public function new()
	{
        super();
        
		var startButton:FlxButton = new FlxButton(0, 0, "Start", onStart);
		startButton.x = (FlxG.width - startButton.width) * 0.5;
		startButton.y = 380;
		
		add(startButton);
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
}
