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
import openfl.display.BitmapData;
import openfl.filters.DropShadowFilter;

using flixel.util.FlxAngle;

/**
 * A Power Up
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PowerUp extends FlxNapeSprite
{
    public static var CB_POWER_UP:CbType = new CbType();
    
    public static inline var TYPE_EXTRA_JUMP:String = 'extra-jump';
    
    private var _dropShadowFilter:DropShadowFilter;
    private var _spriteFilter:FlxSpriteFilter;
    
    private var _powerUpType:String;
    private var _powerUpImageBitmapData:BitmapData;
    
    public function new(X:Float = 0, Y:Float = 0, PowerUpType:String = PowerUp.TYPE_EXTRA_JUMP)
    {
        super(X, Y);
        
        _powerUpType = PowerUpType;
        
        setPosition(X, Y);
        loadGraphic(getImageBitmapData());
        createCircularBody(width * 0.5);
        antialiasing = true;
        setBodyMaterial(-1.0, .5, .5, 2);
        
        body.cbTypes.add(PowerUp.CB_POWER_UP);
        body.userData.data = this;
        
        _dropShadowFilter = new DropShadowFilter(5, 0, 0, .3, 4, 4, 1, 1);
        _spriteFilter = new FlxSpriteFilter(this, 50, 50);
        _spriteFilter.addFilter(_dropShadowFilter);
    }
    
    public function getType():String
    {
        return _powerUpType;
    }
    
    public function getImageBitmapData():BitmapData
    {
        if (_powerUpImageBitmapData == null) {
            _powerUpImageBitmapData = Assets.getBitmapData("images/power-ups/" + _powerUpType + ".png");
        }
        
        return _powerUpImageBitmapData;
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
        
        _dropShadowFilter.angle = 45 - angle;
        _spriteFilter.applyFilters();
        
        super.update();
    }
}
