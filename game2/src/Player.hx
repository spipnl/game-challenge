package;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import openfl.Assets;
import openfl.filters.DropShadowFilter;

using flixel.util.FlxAngle;

/**
 * The Player
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Player extends FlxNapeSprite
{
	public static var CB_PLAYER:CbType = new CbType();
	
	@:isVar public var canJump(get, set):Bool = true;
	
	private var moveSpeed:Float = 60;
	private var jumpSpeed:Float = 1200;
	
	private var xText:FlxText;
	private var yText:FlxText;
	private var zText:FlxText;
    
    private var dropShadowFilter:DropShadowFilter;
    private var spriteFilter:FlxSpriteFilter;
	
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		
		setPosition(X, Y);
		loadGraphic(Assets.getBitmapData("images/player.png"));
		createCircularBody(width * 0.5);
		antialiasing = true;
		setBodyMaterial(-1.0, .5, .5, 2);
		setDrag(0.98, 1);
		
		body.cbTypes.add(Player.CB_PLAYER);
		body.userData.data = this;
        
        dropShadowFilter = new DropShadowFilter(5, 0, 0, .3, 4, 4, 1, 1);
		spriteFilter = new FlxSpriteFilter(this, 50, 50);
        spriteFilter.addFilter(dropShadowFilter);
	}
	
	public function get_canJump():Bool
	{
		return canJump;
	}
	
	public function set_canJump(CanJump:Bool):Bool
	{
		canJump = CanJump;

		return canJump;
	}
	
	private function movement():Void
	{
		#if (android || ios)
			if (FlxG.accelerometer.isSupported) {
				var accelX = -Math.max(-1, Math.min(1, FlxG.accelerometer.x * 5));
				
				body.applyImpulse(new Vec2(moveSpeed * accelX, 0));
				
				if (FlxG.mouse.justPressed && canJump)
				{
                    jump();
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
			
			if (FlxG.keys.anyJustPressed(["SPACE", "UP", "W"]) && canJump)
			{
                jump();
			}
		#end
	}
    
    private function jump():Void
    {
		FlxG.sound.play("jump");
		body.velocity.y = -jumpSpeed;
    }
	
	override public function update():Void
	{
		movement();
		
		if (body.position.x > FlxG.width) {
			body.position.x = 0;
		}
		
		if (body.position.x < 0) {
			body.position.x = FlxG.width;
		}
        
		dropShadowFilter.angle = 45 - angle;
        spriteFilter.applyFilters();
		
		super.update();
	}
}

