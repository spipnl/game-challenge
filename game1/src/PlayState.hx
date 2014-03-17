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
	private var _topMenu:TopMenu;
	
	private static var _justDied:Bool = false;
	
	private var _level:TiledLevel;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public var targets:FlxGroup;
	public var cannon:Cannon;
	
	override public function create():Void 
	{
		//FlxG.sound.playMusic("gameloop");
		
		createFloor();
		
		_topMenu = new TopMenu();
		_topMenu.leftTitle = "SHOOT THE COINS!";
		
		FlxG.cameras.bgColor = 0xffaaaaaa;
		//FlxG.debugger.visible = true;
		
		_level = new TiledLevel("assets/levels/level_01.tmx");
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
		add(_topMenu);
	}
	
	private function createFloor():Void
	{
		// CREATE FLOOR TILES
		var	FloorImg = Assets.getBitmapData("assets/images/fresh_snow.png");
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
		super.update();
		
		FlxG.collide(_level.foregroundTiles, _bullets);
		FlxG.overlap(_bullets, targets, hitTarget);
		
		// Remove bullets that are (almost) still
		_bullets.forEachAlive(function(bullet:Bullet) {
			if (bullet.velocity.x == 0 && bullet.velocity.y <= 0 && bullet.velocity.y >= -4 && bullet.isTouching(FlxObject.ANY)) {
				bullet.kill();
			}
		});
	}
	
	private function hitTarget(Bullet:FlxObject, Target:FlxObject):Void
	{
		Target.kill();
		FlxG.sound.play("pling");
		_topMenu.leftTitle = "SCORE: " + (targets.countDead() * 100);
		
		if (targets.countLiving() == 0)
		{
			FlxG.camera.shake(0.01, 0.2, FlxG.resetState);
		}
	}
}