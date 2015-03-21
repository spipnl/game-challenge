package;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import nape.callbacks.CbType;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;

/**
 * A Row of Platforms
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class LevelRow extends FlxSpriteGroup
{
	public function new(X:Float, Y:Float, platforms:FlxSpriteGroup, gameSpeed:Int)
	{
		super();
		
		var beginPosition:Float = 0;
		
		do
		{
			var platform:Platform;
			do
			{
				platform = cast(platforms.getRandom());
			} while (platform.alive);
			
			platform.body.position.x = beginPosition + platform.width * 0.5;
			platform.body.position.y = - 32;
			platform.revive();
			platform.health = 100;
            platform.gameSpeed = gameSpeed;
			
			beginPosition += platform.platformWidth;
		} while (beginPosition < FlxG.width);
	}
}
