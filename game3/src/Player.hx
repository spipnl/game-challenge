package;

import flixel.FlxG;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

class Player extends FlxNapeSprite
{
    private var numberOfBullets:Int;
    private var maxSpeed:Int = 200;
    
    public function new() 
    {
        super(100,100);
        
        //FlxSpriteUtil.drawCircle(this, 30, 30, 30);
        makeGraphic(40, 40, FlxColor.TRANSPARENT);
        createCircularBody(width * 0.5);
        
		antialiasing = true;
        body.allowRotation = true;
        body.allowMovement = true;
        
        //setBodyMaterial(0, .2, .4, 20);
        setBodyMaterial(0.4, 0.9, 2, 0.7, 0.005);
        //this.kill();
        
        FlxSpriteUtil.drawCircle(this, width * 0.5, height * 0.5, width * 0.5, 0xddaa0000);
        //createCircularBody(30);
        
            trace('move');
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
        var moveSpeed = 50;
        var impulse:Vec2 = new Vec2(0, moveSpeed);
        
        if (FlxG.keys.anyPressed(["UP"]) && FlxG.keys.anyPressed(["LEFT"]))
        {
            impulse.angle = Math.PI * -0.75;
        }
        else if (FlxG.keys.anyPressed(["UP"]) && FlxG.keys.anyPressed(["RIGHT"]))
        {
            impulse.angle = Math.PI * -0.25;
        }
        else if (FlxG.keys.anyPressed(["DOWN"]) && FlxG.keys.anyPressed(["LEFT"]))
        {
            impulse.angle = Math.PI * 0.75;
        }
        else if (FlxG.keys.anyPressed(["DOWN"]) && FlxG.keys.anyPressed(["RIGHT"]))
        {
            impulse.angle = Math.PI * 0.25;
        }
        else if (FlxG.keys.anyPressed(["UP"]))
        {
            impulse.angle = Math.PI * -0.5;
        }
        else if (FlxG.keys.anyPressed(["DOWN"]))
        {
            impulse.angle = Math.PI * 0.5;
        }
        else if (FlxG.keys.anyPressed(["LEFT"]))
        {
            impulse.angle = Math.PI;
        }
        else if (FlxG.keys.anyPressed(["RIGHT"]))
        {
            impulse.angle = 0;
        }
        else
        {
            impulse = null;
        }
        
        if (impulse != null)
        {
            body.applyImpulse(impulse);
        }
        
        if (body.velocity.length > maxSpeed)
        {
            body.velocity.length = maxSpeed;
        }
    }
    
    override public function update():Void
    {
        movement();
        
        super.update();
    }
}
