package;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
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
	public static var CB_PLATFORM:CbType = new CbType();
	
	public function new(X:Float, Y:Float)
	{
		super();
		
		setPosition(X, Y);
		loadGraphic("images/level/elementStone032.png");
		createRectangularBody(width, height, BodyType.KINEMATIC);
		antialiasing = true;
		setBodyMaterial(.5, .5, .5, 2);
		body.velocity.y = 100;
		
		body.cbTypes.add(Platform.CB_PLATFORM);
	}
}