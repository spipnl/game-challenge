package ;

import flash.display.BitmapData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class Background extends FlxSpriteGroup
{    
    private var _bigCloudInterval:Int = 200;
    private var _smallCloudInterval:Int = 150;
    
    private var _backgroundEndColor:Int =  0xFF001233;
    private var _colorTween:FlxTween;
    private var _colorBackground:FlxSprite;
    
    private var _startBackground:FlxSprite;
    public var bigClouds:FlxSpriteGroup;
    public var smallClouds:FlxSpriteGroup;
    
    private var _started:Bool = false;
    
    @:isVar public var gameSpeed(get, set):Int;
    
    public function new(X:Float=0, Y:Float=0) 
    {
        super(X, Y);
        
        _colorBackground = new FlxSprite();
        _colorBackground.alpha = 0;
        _colorBackground.makeGraphic(FlxG.width, FlxG.height, _backgroundEndColor);
        
        _startBackground = new FlxSprite(0, 0, "images/colored_desert.png");
        
        bigClouds = new FlxSpriteGroup();
        for (i in 0...10) {
            var bigCloud:FlxSprite = new FlxSprite();
            bigCloud.loadGraphic("images/bigCloud.png");
            bigCloud.alpha = 0.5;
            bigCloud.kill();
            bigClouds.add(bigCloud);
        }
        
        smallClouds = new FlxSpriteGroup();
        for (i in 0...20) {
            var smallCloud:FlxSprite = new FlxSprite();
            smallCloud.loadGraphic("images/smallCloud.png");
            smallCloud.alpha = 0.5;
            smallCloud.kill();
            smallClouds.add(smallCloud);
        }
        
        add(_colorBackground);
        add(_startBackground);
    }
    
    public function start():Void
    {
        _started = true;
    }
    
    public function get_gameSpeed():Int
    {
        return gameSpeed;
    }
    
    public function set_gameSpeed(GameSpeed:Int):Int
    {
        gameSpeed = GameSpeed;
        
        return gameSpeed;
    }
    
    override public function update():Void
    {
        if (_started)
        {
            if (_startBackground.y < FlxG.height)
            {
                _startBackground.y += gameSpeed / 80;
            }
            else
            {
                if (_colorTween == null)
                {
                    // Slowly change the background color from light blue to dark blue (space)
                    _colorTween = FlxTween.tween(_colorBackground, {alpha: 1}, 600);
                }
            }
            if (_startBackground.y > FlxG.height * 0.5)
            {   
                var newBigCloud:Bool = true;
                bigClouds.forEachAlive(function(bigCloud:FlxSprite) {
                    if (gameSpeed > 0) {
                        bigCloud.y += bigCloud.velocity.y;
                    }
                    if (bigCloud.y < _bigCloudInterval) {
                        newBigCloud = false;
                    }
                    if (!bigCloud.isOnScreen()) {
                        bigCloud.kill();
                    }
                });
                
                // Only add a new cloud when we are not yet in space (background tween ended)
                if (newBigCloud && (_colorTween == null || _colorTween.active)) {
                    var bigCloud:FlxSprite = bigClouds.recycle(FlxSprite);
                    bigCloud.x = FlxG.width * Math.random() - bigCloud.width * 0.5;
                    bigCloud.y = -bigCloud.height;
                    bigCloud.velocity.y = gameSpeed / (40 + 10 * Math.random());
                    
                    _bigCloudInterval = Std.int(50 + 250 * Math.random());
                }
                
                var newSmallCloud:Bool = true;
                smallClouds.forEachAlive(function(smallCloud:FlxSprite) {
                    if (gameSpeed > 0) {
                        smallCloud.y += smallCloud.velocity.y;
                    }
                    if (smallCloud.y < _smallCloudInterval) {
                        newSmallCloud = false;
                    }
                    if (!smallCloud.isOnScreen()) {
                        smallCloud.kill();
                    }
                });
                
                // Only add a new cloud when we are not yet in space (background tween ended)
                if (newSmallCloud && (_colorTween == null || _colorTween.active)) {
                    var smallCloud:FlxSprite = smallClouds.recycle(FlxSprite);
                    smallCloud.x = FlxG.width * Math.random() - smallCloud.width * 0.5;
                    smallCloud.y = -smallCloud.height;
                    smallCloud.velocity.y = gameSpeed / (120 + 10 * Math.random());
                    
                    _smallCloudInterval = Std.int(10 + 200 * Math.random());
                }
            }
        }
    }
}
