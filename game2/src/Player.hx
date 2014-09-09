package;

import flixel.FlxG;
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
	private var playerAcceleration:Float = 300;
	private var maxSpeed:Float = 300;
	private var zeroFriction:Material = new Material(0,0,0);
	private var normalFriction:Material = new Material(0,1,2);
	
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
		var speed = 50;
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			body.applyImpulse(new Vec2( -speed, 0));
		}
		
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			body.applyImpulse(new Vec2(speed, 0));
		}
		
		
		if (FlxG.keys.anyJustPressed(["SPACE", "UP", "W"]) /*&& isTouching(FlxObject.FLOOR)*/)
		{
			body.velocity.y = -500;
		}
	}
	
	override public function update():Void
	{
		movement();
		
		super.update();
	}
}

