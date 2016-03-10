package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.math.FlxAngle;
import openfl.Assets;

class Player extends FlxGroup
{
    private var tankWidth:Int = 64;
    private var tankHeight:Int = 64;
    private var tankBarrelWidth:Int = 20;
    private var tankBody:FlxNapeSprite;
    private var tankBarrel:FlxSprite;
    private var numberOfBullets:Int;
    private var maxSpeed:Int = 200;
    
    public function new() 
    {
        super();
        
        tankBody = new FlxNapeSprite(100, 100);
        
        //FlxSpriteUtil.drawCircle(this, 30, 30, 30);
        //makeGraphic(64, 64, FlxColor.TRANSPARENT);
        tankBody.loadGraphic(Assets.getBitmapData("images/tanks/basic.png"));
        tankBody.antialiasing = true;
        //createCircularBody(width * 0.5);
        tankBody.createRectangularBody(tankWidth, tankHeight);
        
        tankBarrel = new FlxSprite(0, 0, Assets.getBitmapData("images/tanks/barrel.png"));
        tankBarrel.origin.set(6, tankBarrelWidth * 0.5);
		
        
		tankBody.antialiasing = true;
        //body.allowRotation = true;
        //body.allowMovement = true;
        
        //setBodyMaterial(0, .2, .4, 20);
        tankBody.setBodyMaterial(0.4, 0.9, 2, 0.7, 0.005);
        //this.kill();
        
        //FlxSpriteUtil.drawCircle(this, width * 0.5, height * 0.5, width * 0.5, 0xddaa0000);
        //createCircularBody(30);
        
        add(tankBody);
        add(tankBarrel);
    }
    
    private function init()
    {
        numberOfBullets = 3;
    }
    
    public function getNumberOfBullets()
    {
        return numberOfBullets;
    }
    
    public function shoot()
    {
        numberOfBullets--;
    }
    
    private function movement():Void
    {
        var moveSpeed = 64;
        var impulse:Vec2 = new Vec2(0, moveSpeed);
        
		var gamepad = FlxG.gamepads.lastActive;
        
        FlxG.watch.add(FlxG.gamepads, 'numActiveGamepads');
        
        var up = FlxG.keys.anyPressed(["UP"]);
        var down = FlxG.keys.anyPressed(["DOWN"]);
        var left = FlxG.keys.anyPressed(["LEFT"]);
        var right = FlxG.keys.anyPressed(["RIGHT"]);
        
		if (gamepad != null)
        {
            up = up || gamepad.pressed.DPAD_UP;
            down = down || gamepad.pressed.DPAD_DOWN;
            left = left || gamepad.pressed.DPAD_LEFT;
            right = right || gamepad.pressed.DPAD_RIGHT;
        }
        
        if (up && left)
        {
            impulse.angle = Math.PI * -0.75;
        }
        else if (up && right)
        {
            impulse.angle = Math.PI * -0.25;
        }
        else if (down && left)
        {
            impulse.angle = Math.PI * 0.75;
        }
        else if (down && right)
        {
            impulse.angle = Math.PI * 0.25;
        }
        else if (up)
        {
            impulse.angle = Math.PI * -0.5;
        }
        else if (down)
        {
            impulse.angle = Math.PI * 0.5;
        }
        else if (left)
        {
            impulse.angle = Math.PI;
        }
        else if (right)
        {
            impulse.angle = 0;
        }
        else
        {
            impulse = null;
        }
        
        if (impulse != null)
        {
            tankBody.body.applyImpulse(impulse);
            //body.applyAngularImpulse(impulse.angle);
            tankBody.body.rotation = impulse.angle;
        }
        
        if (tankBody.body.velocity.length > maxSpeed)
        {
            //body.velocity.length = maxSpeed;
        }
        
        tankBarrel.x = tankBody.x + tankWidth * 0.5 - 6;
        tankBarrel.y = tankBody.y + tankHeight * 0.5 - tankBarrelWidth * 0.5;
        tankBarrel.angle = tankBody.body.rotation * FlxAngle.TO_DEG;
    }
    
    override public function update(elapsed:Float):Void
    {
        
        movement();
        
        super.update(elapsed);
    }
}
