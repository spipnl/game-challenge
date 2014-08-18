package; 

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import openfl.Assets;

/**
 * Initial MainMenu
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MainMenuState extends FlxState
{
	public var player:Player;
	
	public function new()
	{
		super();
	}
	
	override public function create():Void 
	{
		createBackground();
		
		var menuTitle = new FlxSprite(0, 0, Assets.getBitmapData("images/menutitle.png"));
		menuTitle.x = (FlxG.width - menuTitle.width) * 0.5;
		menuTitle.y = 200;
		
		player = new Player();
		player.x = (FlxG.width - player.width) * 0.5;
		player.y = (FlxG.height - player.height) * 0.5;
		
		add(player);
		add(menuTitle);
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
}