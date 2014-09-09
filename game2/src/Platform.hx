package;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;

/**
 * A Platform
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Platform extends FlxNapeSprite
{
	public function new(X:Float, Y:Float)
	{
		super();
		
		setPosition(X, Y);
		loadGraphic("images/level/elementStone032.png");
		createRectangularBody(width, height, BodyType.STATIC);
		antialiasing = true;
		setBodyMaterial(.5, .5, .5, 2);
	}
}