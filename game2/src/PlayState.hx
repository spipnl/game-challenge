package; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import openfl.Assets;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxState
{
	public var player:Player;
	
	override public function create():Void 
	{
		player = new Player();
		player.x = (FlxG.width - player.width) * 0.5;
		player.y = (FlxG.height - player.height) * 0.5;
		
		add(player);
	}
}