package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxState
{
	private var _topTitleBar:TitleBar;
	
	private static var _justDied:Bool = false;
	
	private var _level:TiledLevel;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public var targets:FlxGroup;
	public var cannon:Cannon;
	
	private var _currentMap:Int;
	
	public function new(currentMap)
	{
		_currentMap = currentMap;
		super();
	}
	
	override public function create():Void 
	{
		FlxG.sound.playMusic("gameloop");
		
		createFloor();
		
		_topTitleBar = new TitleBar();
		_topTitleBar.middleTitle = "Level " + _currentMap;
		
		FlxG.cameras.bgColor = 0xffaaaaaa;
		//FlxG.debugger.visible = true;
		
		// Build the map path with padded zeros for two digits
		var mapPath = "levels/level_" + StringTools.lpad(Std.string(_currentMap), "0", 2) + ".tmx";
		trace(_currentMap);
		
		_level = new TiledLevel(mapPath);
		// Add tilemaps
		add(_level.foregroundTiles);
		
		// Draw coins first
		targets = new FlxGroup();
		add(targets);
		
		// Load objects
		_level.loadObjects(this);
		
		// Add background tiles after adding level objects, so these tiles render on top of player
		add(_level.backgroundTiles);
		
		_bullets = cannon.getBullets();
		
		//add(_status);
		add(_topTitleBar);
	}
	
	private function createFloor():Void
	{
		// CREATE FLOOR TILES
		var	FloorImg = Assets.getBitmapData("images/fresh_snow.png");
		var ImgWidth = FloorImg.width;
		var ImgHeight = FloorImg.height;
		var i = 0; 
		var j = 0; 
		
		while ( i <= FlxG.width )
		{
			while ( j <= FlxG.height )
			{
				var spr = new FlxSprite(i, j, FloorImg);
				add(spr);
				j += ImgHeight;
			}
			i += ImgWidth;
			j = 0;
		}
	}
	
	override public function update():Void 
	{
		FlxG.collide(_level.foregroundTiles, _bullets);
		FlxG.overlap(_bullets, targets, hitTarget);
		
		// Remove bullets that are (almost) still
		_bullets.forEachAlive(function(bullet:Bullet) {
			if (bullet.velocity.x == 0 && bullet.velocity.y <= 0 && bullet.velocity.y >= -4 && bullet.isTouching(FlxObject.ANY)) {
				bullet.kill();
			}
		});
		_topTitleBar.leftTitle = "Power: " + (cannon.getPower());
		_topTitleBar.rightTitle = "Bullets left: " + (cannon.getBulletsLeft());
		
		super.update();
	}
	
	private function hitTarget(Bullet:FlxObject, Target:FlxObject):Void
	{
		Target.kill();
		FlxG.sound.play("pling");
		
		if (targets.countLiving() == 0)
		{
			FlxG.camera.shake(0.01, 0.2, nexLevel);
		}
	}
	
	private function nexLevel():Void
	{
		_currentMap += 1;
		FlxG.switchState(new PlayState(_currentMap));
	}
}