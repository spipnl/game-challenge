package;

import flixel.FlxG;
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
		
		// Gravity of the player
		acceleration.y = 600;
	}
	
	override public function update():Void
	{
		if (FlxG.mouse.justPressed) {
			velocity.y = -600;
		}
		
		super.update();
	}
}