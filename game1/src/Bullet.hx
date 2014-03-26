package;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxVelocity;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * The Bullet from the Canon
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Bullet extends FlxSprite 
{
	/**
	 * Create a new Bullet object. Generally this would be used by the game to create a pool of bullets that can be recycled later on, as needed.
	 */
	public function new() 
	{
		super();
		makeGraphic(10, 10, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawCircle(this, width * 0.5, width * 0.5, width * 0.5, FlxColor.CHARCOAL);
		
		acceleration.y = 200;
		elasticity = 0.5;
		
		drag.x = 10;
	}
	
	/**
	 * Initialize this bullet by giving it a position, target, and damage amount. Usually used to create a new bullet as it is fired by a tower.
	 * 
	 * @param	X			The desired X position.
	 * @param	Y			The desired Y position.
	 */
	public function init(X:Float, Y:Float):Void
	{
		reset( X, Y );
	}
	
	public function shoot(Deg:Int, Strength:Int):Void 
	{
		velocity = FlxVelocity.velocityFromAngle(Deg - 180, Strength * 70);
	}
}