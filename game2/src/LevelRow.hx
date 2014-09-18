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
	public function new(X:Float, Y:Float, platforms:FlxSpriteGroup)
	{
		super();
		
		var platform1:Platform = cast(platforms.recycle(FlxSprite));
		
		platform1.body.position.x = platform1.width + 200 * Math.random();
		platform1.body.position.y = - 32;
		
		var platform2:Platform = cast(platforms.recycle(FlxSprite));
		
		platform2.body.position.x = platform1.body.position.x + platform1.width * 2;
		platform2.body.position.y = platform1.body.position.y;
	}
}