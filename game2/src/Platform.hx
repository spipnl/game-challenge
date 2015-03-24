package;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;
import openfl.filters.DropShadowFilter;

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
	
    private var dropShadowFilter:DropShadowFilter;
    private var spriteFilter:FlxSpriteFilter;
    
	public var breakable:Bool = false;
	
	@:isVar public var gameSpeed(get, set):Int;
	@:isVar public var platformWidth(get, set):Float;
    
	public function new(X:Float, Y:Float, Width:Float = 96, Material:String = Platform.MATERIAL_STONE)
	{
		super();
		
        platformWidth = Width;
        
		setPosition(X, Y);
        
        setMaterial(Material);
        
		createRectangularBody(width, height, BodyType.KINEMATIC);
		antialiasing = true;
		setBodyMaterial(.5, .5, .5, 2);
		health = 100;
		
		body.cbTypes.add(Platform.CB_PLATFORM);
		body.userData.data = this;
        
        //dropShadowFilter = new DropShadowFilter(5, 45, 0, .3, 4, 4, 1, 1);
		//spriteFilter = new FlxSpriteFilter(this, 50, 50);
        //spriteFilter.addFilter(dropShadowFilter);
	}
    
    public function setMaterial(Material:String)
    {
		loadGraphic("images/level/" + Material + "-" + Std.string(platformWidth) + ".png", true, Std.int(platformWidth), 32);
        
		if (Material == Platform.MATERIAL_GLASS)
		{
			body.cbTypes.add(Platform.CB_PLATFORM_ONE_WAY);
			breakable = false;
		}
		if (Material == Platform.MATERIAL_WOOD)
		{
			body.cbTypes.remove(Platform.CB_PLATFORM_ONE_WAY);
			breakable = true;
		}
    }
    
	public function get_gameSpeed():Int
	{
		return gameSpeed;
	}
	
	public function set_gameSpeed(GameSpeed:Int):Int
	{
		gameSpeed = GameSpeed;
		body.velocity.y = gameSpeed;
		
		return gameSpeed;
	}
	
	public function get_platformWidth():Float
	{
		return platformWidth;
	}
	
	public function set_platformWidth(PlatformWidth:Float):Float
	{
		platformWidth = PlatformWidth;
		
		return platformWidth;
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
