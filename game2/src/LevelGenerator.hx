package;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import nape.callbacks.CbType;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;
import flixel.util.FlxArrayUtil;
import flixel.tweens.FlxTween;

import flixel.util.FlxRandom;

/**
 * A Row of Platforms
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class LevelGenerator extends FlxSpriteGroup
{
    public var platforms:FlxSpriteGroup;
    
    @:isVar public var gameSpeed(get, set):Int;
    
    private var _newLevel:Bool = false;
    private var _currentLevel:Int = 1;
    private var _levelRowCounter:Int = 0;
    private var _nextRowPosition:Float = 0;
    private var _started = false;
    
    private var platformCollection:Map<String,Map<Int,FlxSpriteGroup>>;
    //private var levels:Map<Int,Map<Int,Map<String,Int>>>;
    private var levels:Map<Int,Array<Map<String, Int>>>;
    
    public function new()
    {
        var screenWidth = FlxG.width;
        
        super();
        
        platformCollection = new Map();
        
        platforms = new FlxSpriteGroup();
        
        generatePlatforms(3, Platform.MATERIAL_STONE, 100);
        generatePlatforms(2, Platform.MATERIAL_STONE, 100);
        generatePlatforms(1, Platform.MATERIAL_STONE, 100);
        generatePlatforms(3, Platform.MATERIAL_GLASS, 100);
        generatePlatforms(2, Platform.MATERIAL_GLASS, 100);
        generatePlatforms(1, Platform.MATERIAL_GLASS, 100);
        generatePlatforms(3, Platform.MATERIAL_WOOD, 100);
        generatePlatforms(2, Platform.MATERIAL_WOOD, 100);
        generatePlatforms(1, Platform.MATERIAL_WOOD, 100);
        
        levels = [
            1 => [
                [
                    Platform.MATERIAL_GLASS => 15,
                ],
            ],
            2 => [
                [
                    Platform.MATERIAL_GLASS => 8,
                ],
                [
                    Platform.MATERIAL_GLASS => 10,
                ],
            ],
            3 => [
                [
                    Platform.MATERIAL_GLASS => 5,
                    Platform.MATERIAL_STONE => 4,
                ],
                [
                    Platform.MATERIAL_GLASS => 7,
                    Platform.MATERIAL_STONE => 5,
                ],
                [
                    Platform.MATERIAL_GLASS => 4,
                    Platform.MATERIAL_STONE => 6,
                ],
            ],
            4 => [
                [
                    Platform.MATERIAL_STONE => 6,
                ],
                [
                    Platform.MATERIAL_STONE => 7,
                ],
                [
                    Platform.MATERIAL_STONE => 2,
                ],
            ],
            5 => [
                [
                    Platform.MATERIAL_GLASS => 3,
                ],
                [
                    Platform.MATERIAL_GLASS => 2,
                ],
                [
                    Platform.MATERIAL_GLASS => 4,
                ],
            ],
            6 => [
                [
                    Platform.MATERIAL_GLASS => 5,
                    Platform.MATERIAL_WOOD => 4,
                ],
                [
                    Platform.MATERIAL_GLASS => 4,
                    Platform.MATERIAL_WOOD  => 5,
                ],
            ],
            7 => [
                [
                    Platform.MATERIAL_GLASS => 5,
                    Platform.MATERIAL_STONE => 5,
                    Platform.MATERIAL_WOOD => 5,
                ],
                [
                    Platform.MATERIAL_GLASS => 4,
                    Platform.MATERIAL_STONE => 4,
                    Platform.MATERIAL_WOOD => 7,
                ],
            ],
            8 => [
                [
                    Platform.MATERIAL_WOOD => 15,
                ],
                [
                    Platform.MATERIAL_STONE => 5,
                ],
                [
                    Platform.MATERIAL_STONE => 3,
                ],
            ],
            9 => [
                [
                    Platform.MATERIAL_WOOD => 3,
                ],
                [
                    Platform.MATERIAL_WOOD => 2,
                ],
            ],
            10 => [
                [
                    Platform.MATERIAL_GLASS=> 4,
                ],
                [
                    Platform.MATERIAL_STONE => 4,
                ],
                [
                    Platform.MATERIAL_WOOD => 4,
                ],
            ],
        ];
    }
    
    public function start():Void
    {
        drawRow(600, 1);
        drawRow(400, 1);
        drawRow(200, 1);
        
        _currentLevel = 2;
        
        _started = true;
    }
    
    public function goToNextLevel():Void
    {
        _currentLevel++;
        
        if (_currentLevel > Lambda.count(levels))
        {
            _currentLevel = 2;
        }
        
        _newLevel = true;
    }
    
    public function get_gameSpeed():Int
    {
        return gameSpeed;
    }
    
    public function set_gameSpeed(GameSpeed:Int):Int
    {
        gameSpeed = GameSpeed;
        
        platforms.forEachAlive(function(platform:FlxSprite)
        {
            var platform:Platform = cast(platform);
            platform.gameSpeed = gameSpeed;
        });
        
        return gameSpeed;
    }
    
    private function generatePlatforms(platformWidth:Int, platformMaterial:String, amount:Int):Void
    {
        for (i in 0...amount)
        {
            var platform:Platform;
            platform = new Platform(0, 0, platformWidth, platformMaterial);
            platform.kill();
            platforms.add(platform);
            
            if (platformCollection[platformMaterial] == null)
            {
                platformCollection[platformMaterial] = new Map();
            }
            
            if (platformCollection[platformMaterial][platformWidth] == null)
            {
                platformCollection[platformMaterial][platformWidth] = new FlxSpriteGroup();
            }
            
            platformCollection[platformMaterial][platformWidth].add(platform);
        }
    }
    
    private function drawRow(Ypos:Float, Level:Int):Void
    {
        var beginPosition:Float = 0;
        var level = levels[Level];
        var levelElements = level[Std.random(level.length)];
        //var level = levels[Math.round(Math.random() * 5)+1];
        
        var createdPlatforms:Array<Platform> = new Array();
        
        var platformAmount:Int = 0;
        for (platformMaterial in levelElements.keys())
        {
            var materialAmount:Int = levelElements[platformMaterial];
            platformAmount += materialAmount;
            
            do
            {
                var platformSize:Int = Math.round(Math.random()) + 2;
                if (platformSize > materialAmount) {
                    platformSize = materialAmount;
                }
                materialAmount -= platformSize;
                
                var platform:Platform = cast(platformCollection[platformMaterial][platformSize].getFirstDead());
                platform.revive();
                platform.health = 100;
                platform.alpha = 0;
                
                createdPlatforms.push(platform);
            }
            while (materialAmount > 0);
        }
        
        var spaceAmount = 15 - platformAmount;
        
        FlxRandom.shuffleArray(createdPlatforms, 2);
        
        for (platform in createdPlatforms)
        {
            if (spaceAmount > 0)
            {
                var gap:Int = Math.round(spaceAmount * Math.random());
                spaceAmount -= gap;
                beginPosition += gap * 36;
            }
            
            platform.body.position.x = beginPosition + platform.width * 0.5;
            platform.body.position.y = Ypos;
            platform.gameSpeed = gameSpeed;
            
            FlxTween.tween(platform, { alpha: 1 }, 1);
            
            beginPosition += platform.platformWidth * 36;
        }
    }
    
    override public function update():Void
    {
        platforms.forEachAlive(function(platform:FlxSprite)
        {
            var platform:Platform = cast(platform);
            if (platform.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height) 
            {
                platform.kill();
            }
        });
        
        if (_started)
        {
            _levelRowCounter += gameSpeed;
            
            if (_levelRowCounter >= _nextRowPosition)
            {
                _nextRowPosition = 7500 + 10000 * Math.random();
                
                if (_newLevel)
                {
                    _newLevel = false;
                    drawRow(50, 1);
                }
                else
                {
                    drawRow(50, _currentLevel);
                }
                
                _levelRowCounter = 0;
            }
        }
    }
}
