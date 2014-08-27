package; 

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import openfl.Assets;

/**
 * Initial MainMenu
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MainMenuState extends FlxState
{
	private var _menuTitle:FlxSprite;
	
	public function new()
	{
		super();
	}
	
	override public function create():Void 
	{
		createBackground();
		
		_menuTitle = new FlxSprite(0, 0, Assets.getBitmapData("images/menutitle.png"));
		_menuTitle.x = (FlxG.width - _menuTitle.width) * 0.5;
		_menuTitle.y = 200;
		
		var startButton:FlxButton = new FlxButton(0, 0, "Start", onStart);
		startButton.x = (FlxG.width - startButton.width) * 0.5;
		startButton.y = 380;
		
		add(startButton);
		add(_menuTitle);
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
		FlxTween.tween(_menuTitle, {alpha: 0}, 0.5, {complete: function(tween:FlxTween){
			FlxG.switchState(new PlayState());
		}});
	}
}
