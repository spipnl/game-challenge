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
	public static var CB_PLATFORM_ONE_WAY:CbType = new CbType();
	
	public static inline var MATERIAL_STONE:String = 'stone';
	public static inline var MATERIAL_GLASS:String = 'glass';
	public static inline var MATERIAL_WOOD:String = 'wood';
	
	public var breakable:Bool = false;
	
	public function new(X:Float, Y:Float, Width:Float = 100, Material:String = Platform.MATERIAL_STONE)
	{
		super();
		
		setPosition(X, Y);
		loadGraphic("images/level/" + Material + "-" + Std.string(Width) + ".png", true, Std.int(Width), 32);
		createRectangularBody(width, height, BodyType.KINEMATIC);
		antialiasing = true;
		setBodyMaterial(.5, .5, .5, 2);
		body.velocity.y = 100;
		health = 100;
		
		body.cbTypes.add(Platform.CB_PLATFORM);
		body.userData.data = this;
		
		if (Material == Platform.MATERIAL_GLASS)
		{
			body.cbTypes.add(Platform.CB_PLATFORM_ONE_WAY);
		}
		if (Material == Platform.MATERIAL_WOOD)
		{
			breakable = true;
		}
	}
	
	override public function update():Void
	{
		if (breakable && health <= 0)
		{
			kill();
		}
		
		if (breakable) {
			if (health >= 80) {
				animation.frameIndex = 0;
			} else if (health >= 30 && animation.frameIndex == 0) {
				animation.frameIndex = 1;
			} else if (health < 30 && animation.frameIndex == 1) {
				animation.frameIndex = 2;
			}
		}
		
		
		
		super.update();
	}
}