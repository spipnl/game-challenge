package;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import nape.callbacks.CbType;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;

/**
 * A Row of Platforms
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class LevelGenerator extends FlxSpriteGroup
{
	public var platforms:FlxSpriteGroup;
    
	@:isVar public var gameSpeed(get, set):Int;
    
	private var levelRowCounter:Int = 0;
	private var currentLevel:Int = 1;
    
    private var platformCollection:Map<String,Map<Int,FlxSpriteGroup>>;
    private var levels:Map<Int,Map<String,Int>>;
    
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
                Platform.MATERIAL_GLASS => 15,
            ],
            2 => [
                Platform.MATERIAL_GLASS => 4,
                Platform.MATERIAL_STONE => 4,
            ],
        ];
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
	
	private function generatePlatforms(platformWidth:Int, platformMaterial:String, amount:Int):Void
	{
		for (i in 0...amount)
		{
			var platform:Platform;
			platform = new Platform(0, 0, platformWidth, platformMaterial);
			platform.kill();
			platforms.add(platform);
            if (platformCollection[platformMaterial] == null) {
                platformCollection[platformMaterial] = new Map();
            }
            if (platformCollection[platformMaterial][platformWidth] == null) {
                platformCollection[platformMaterial][platformWidth] = new FlxSpriteGroup();
            }
            platformCollection[platformMaterial][platformWidth].add(platform);
		}
	}
	
	override public function update():Void
    {
		platforms.forEachAlive(function(platform:FlxSprite) {
			var platform:Platform = cast(platform);
			if (platform.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height) 
			{
				platform.kill();
			}
		});
		
		levelRowCounter += 1;
		if (levelRowCounter > 150)
		{
			levelRowCounter = 0;
            
            var beginPosition:Float = 0;
            var level = levels[currentLevel];
            
            var createdPlatforms:Map = new Map();
            
            for (platformMaterial in level.keys()) {
                var materialAmount:Int = level[platformMaterial];
                
                do
                {
                    var platformSize:Int = Math.round((Math.random() * 2)) + 1;
                    if (platformSize > materialAmount) {
                        platformSize = materialAmount;
                    }
                    materialAmount -= platformSize;
                    
                    var platform:Platform = cast(platformCollection[platformMaterial][platformSize].getFirstDead());
                    //createdPlatforms.add(platform);
                    platform.body.position.x = beginPosition + platform.width * 0.5;
                    platform.body.position.y = - 36;
                    platform.revive();
                    platform.health = 100;
                    platform.gameSpeed = gameSpeed;
                    
                    beginPosition += platform.platformWidth * 36;
                } while (materialAmount > 0);
            }
            
            //createdPlatforms.forEach(function(platform:FlxSprite) {
                //var platform:Platform = cast(platform);
                //
                //platform.body.position.x = beginPosition + platform.width * 0.5;
                //platform.body.position.y = - 36;
                //platform.revive();
                //platform.health = 100;
                //platform.gameSpeed = gameSpeed;
                //
                //beginPosition += platform.platformWidth * 36;
            //});
            
            //
            //do
            //{
                //var platform:Platform = cast(platformCollection[Platform.MATERIAL_GLASS][3].getFirstDead());
                //
                //platform.body.position.x = beginPosition + platform.width * 0.5;
                //platform.body.position.y = - 36;
                //platform.revive();
                //platform.health = 100;
                //platform.gameSpeed = gameSpeed;
                //
                //beginPosition += platform.platformWidth * 36;
            //} while (beginPosition < FlxG.width);
		}
    }
}
