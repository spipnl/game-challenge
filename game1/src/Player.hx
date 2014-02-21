package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

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
		
		makeGraphic(8, 8, FlxColor.CRIMSON);
		maxVelocity.set(80, 200);
		acceleration.y = 100;
		drag.x = maxVelocity.x * 8;
		// Smoother movement by enabling subpixel rendering
		forceComplexRender = true;
		
		/*
		animation.add("default", [0, 1], 3);
		animation.add("jump", [2]);
		animation.play("default");
		*/
	}
	
	override public function update():Void 
	{
		acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			acceleration.x = -maxVelocity.x * 8;
		}
		
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			acceleration.x = maxVelocity.x * 8;
		}
		
		if (FlxG.keys.anyJustPressed(["SPACE", "UP", "W"]) && isTouching(FlxObject.FLOOR))
		{
			velocity.y = -maxVelocity.y / 2;
		}
		
		super.update();
	}
}