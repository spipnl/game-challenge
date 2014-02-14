package;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxVelocity;

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
		makeGraphic(3, 3);
		
		#if !(cpp || neko || js)
		blend = BlendMode.INVERT;
		#end
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
	
	override public function update():Void
	{
		// This bullet missed its target and flew off-screen; no reason to keep it around.
		
		if (!isOnScreen(FlxG.camera)) 
		{
			kill();
			trace('kill');
		}
		velocity.x = 100;
		/*
		// Move toward the target that was assigned in init().
		
		if (_target.alive)
		{
			FlxVelocity.moveTowardsObject(this, _target, 200);
		}
		*/
		super.update();
	}
}