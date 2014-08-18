package;

import flixel.FlxSprite;
import openfl.Assets;

/**
 * The Player
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Player extends FlxSprite
{
	public function new() 
	{
		super();
		
		loadGraphic(Assets.getBitmapData("images/player.png"));
	}
}