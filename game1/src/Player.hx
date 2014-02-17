package;
import flixel.FlxSprite;

/**
 * The Player
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Player extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		/*
		animation.add("default", [0, 1], 3);
		animation.add("jump", [2]);
		animation.play("default");
		*/
	}
}