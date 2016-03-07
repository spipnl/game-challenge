package;

import flixel.effects.FlxSpriteFilter;
import flixel.effects.particles.FlxEmitterExt;
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
class Wall extends FlxNapeSprite
{
    public static var CB_WALL:CbType = new CbType();
    
    public function new(X:Float, Y:Float)
    {
        super();
        
        platformWidth = Width;
        
        setPosition(X, Y);
        
        createRectangularBody(width, height, BodyType.KINEMATIC);
        antialiasing = true;
        setBodyMaterial(.5, .5, .5, 2);
        health = 100;
        
        body.cbTypes.add(Wall.CB_PLATFORM);
    }
}
