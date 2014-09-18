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
	public static inline var MATERIAL_STONE:String = 'stone';
	
	public function new(X:Float, Y:Float, Width:Float = 100, Material:String = Platform.MATERIAL_STONE)
	{
		super();
		
		setPosition(X, Y);
		loadGraphic("images/level/" + Material + "-" + Std.string(Width) + ".png");
		createRectangularBody(width, height, BodyType.KINEMATIC);
		antialiasing = true;
		setBodyMaterial(.5, .5, .5, 2);
		body.velocity.y = 75;
		
		if (Material == Platform.MATERIAL_STONE)
		{
			body.cbTypes.add(Platform.CB_PLATFORM);
		}
	}
}