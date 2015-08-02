package;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
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
 * The Enemy
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Enemy extends FlxNapeSprite
{
    public static var CB_ENEMY:CbType = new CbType();
    
    private var dropShadowFilter:DropShadowFilter;
    private var spriteFilter:FlxSpriteFilter;
    
    public function new(X:Float, Y:Float)
    {
        super(X, Y);
        
        setPosition(X, Y);
        loadGraphic(Assets.getBitmapData("images/enemy.png"));
        createCircularBody(width * 0.5);
        antialiasing = true;
        setBodyMaterial(-1.0, .5, .5, 2);
        
        body.cbTypes.add(Enemy.CB_ENEMY);
        body.userData.data = this;
        
        dropShadowFilter = new DropShadowFilter(5, 0, 0, .3, 4, 4, 1, 1);
        spriteFilter = new FlxSpriteFilter(this, 50, 50);
        spriteFilter.addFilter(dropShadowFilter);
    }
    
    override public function update():Void
    {
        if (body.position.y > FlxG.height + height) {
            kill();
        }
        
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
