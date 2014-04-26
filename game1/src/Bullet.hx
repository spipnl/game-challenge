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
	 * Create a new Bullet object.
	 */
	public function new() 
	{
		super();
		makeGraphic(10, 10, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawCircle(this, width * 0.5, width * 0.5, width * 0.5, FlxColor.CHARCOAL);
		
		// Gravity of the bullet
		acceleration.y = 200;
		// Bounce of the bullet
		elasticity = 0.5;
		// Add drag to slow the bullet down
		drag.x = 10;
	}
	
	/**
	 * Initialize this bullet by giving it a position.
	 * 
	 * @param	X			The desired X position.
	 * @param	Y			The desired Y position.
	 */
	public function init(X:Float, Y:Float):Void
	{
		reset( X, Y );
	}
	
	/**
	 * Shoot the bullet
	 *
	 * @param Deg			The degrees to fire the bullet at
	 * @param Strength		The strength of the power of the bullet
	 */
	public function shoot(Deg:Int, Strength:Int):Void 
	{
		velocity = FlxVelocity.velocityFromAngle(Deg - 180, Strength * 40);
	}
}