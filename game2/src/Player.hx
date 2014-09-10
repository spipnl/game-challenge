package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.addons.nape.FlxNapeSprite;
import nape.geom.Vec2;
import nape.phys.Material;
import openfl.Assets;

using flixel.util.FlxAngle;

/**
 * The Player
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Player extends FlxNapeSprite
{
	private var moveSpeed:Float = 80;
	private var jumpSpeed:Float = 800;
	
	private var xText:FlxText;
	private var yText:FlxText;
	private var zText:FlxText;
	
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		
		setPosition(X, Y);
		loadGraphic(Assets.getBitmapData("images/player.png"));
		createCircularBody(width * 0.5);
		antialiasing = true;
		setBodyMaterial(0.8,1.0,1.4,1.5,0.01);
		setDrag(0.98, 1);
	}
	
	private function movement():Void
	{
		#if (android || ios)
			if (FlxG.accelerometer.isSupported) {
				var accelX = -Math.max(-1, Math.min(1, FlxG.accelerometer.x * 5));
				
				body.applyImpulse(new Vec2(moveSpeed * accelX, 0));
				
				if (FlxG.mouse.justPressed /*&& isTouching(FlxObject.FLOOR)*/)
				{
					body.velocity.y = -jumpSpeed;
				}
			} else {
				trace("No Accelerometer support");
			}
		#else
			if (FlxG.keys.anyPressed(["LEFT", "A"]))
			{
				body.applyImpulse(new Vec2(-moveSpeed, 0));
			}
			
			if (FlxG.keys.anyPressed(["RIGHT", "D"]))
			{
				body.applyImpulse(new Vec2(moveSpeed, 0));
			}
			
			if (FlxG.keys.anyJustPressed(["SPACE", "UP", "W"]) /*&& isTouching(FlxObject.FLOOR)*/)
			{
				body.velocity.y = -jumpSpeed;
			}
		#end
	}
	
	override public function update():Void
	{
		movement();
		
		super.update();
	}
}

