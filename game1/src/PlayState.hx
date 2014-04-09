package; 

import flixel.effects.particles.FlxEmitterExt;
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
import flixel.tweens.FlxTween;
import openfl.Assets;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxState
{
	private var _topTitleBar:TitleBar;
	private var _levelText:FlxText;
	
	private static var _justDied:Bool = false;
	
	private var _level:TiledLevel;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public var targets:FlxGroup;
	public var cannon:Cannon;
	
	private var _explosion:FlxEmitterExt;
	
	private var _currentMap:Int;
	
	public function new(currentMap)
	{
		_currentMap = currentMap;
		super();
	}
	
	override public function create():Void 
	{
		createFloor();
		
		_topTitleBar = new TitleBar();
		_topTitleBar.middleTitle = "Level " + _currentMap;
		
		FlxG.cameras.bgColor = 0xffaaaaaa;
		//FlxG.debugger.visible = true;
		
		// Build the map path with padded zeros for two digits
		var mapPath = "levels/level_" + StringTools.lpad(Std.string(_currentMap), "0", 2) + ".tmx";
		
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
		
		
		// Add exlposion emitter
		_explosion = new FlxEmitterExt();
		_explosion.setRotation(0, 0);
		_explosion.setMotion(0, 5, 0.2, 360, 200, 1.8);
		_explosion.makeParticles("images/particles.png", 1200, 0, true, 0);
		_explosion.setAlpha(1, 1, 0, 0);
		_explosion.gravity = 400;
		add(_explosion);
		
		_levelText = new FlxText(0, 150, FlxG.width);
		_levelText.font = "fonts/OpenSans-Bold.ttf";
		_levelText.alignment = "center";
		_levelText.color = 0x84494a;
		_levelText.size = 48;
		_levelText.text = "LEVEL " + _currentMap;
		_levelText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 4, 1);
		add(_levelText);
		
		FlxG.camera.fade(FlxColor.WHITE, 0.5, true, function() {
			FlxTween.singleVar(_levelText, "alpha", 0, 1);
		});
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
			if (bullet.y > FlxG.height) {
				//trace ("kill " + bullet.y);
				bullet.kill();
			}
		});

		_topTitleBar.leftTitle = "Power: " + (cannon.getPower());
		_topTitleBar.rightTitle = "Bullets left: " + (cannon.getBulletsLeft());
		
		if (_bullets.countLiving() == 0 && cannon.getBulletsLeft() == 0) {
			_levelText.text = "YOU LOSE";
			FlxTween.singleVar(_levelText, "alpha", 1, 2, {complete: onLost});
		}
		
		super.update();
	}
	
	private function onLost(tween:FlxTween):Void
	{
		FlxG.camera.fade(FlxColor.WHITE, 1, false, function() {
			FlxG.switchState(new MainMenuState());
		});
	}
	
	private function onWon(tween:FlxTween):Void
	{
		_currentMap += 1;
		
		FlxG.camera.fade(FlxColor.WHITE, 1, false, function() {
			FlxG.switchState(new PlayState(_currentMap));
		});
	}
	
	private function explode(X:Float = 0, Y:Float = 0):Void
	{
		if (_explosion.visible)
		{
			_explosion.x = X;
			_explosion.y = Y;
			_explosion.start(true, 2, 0, 100);
			_explosion.update();
		}
	}
	
	private function hitTarget(Bullet:FlxObject, Target:FlxObject):Void
	{
		explode(Target.x + Target.width * 0.5, Target.y + Target.height * 0.5);
		Target.kill();
		FlxG.sound.play("pling");
		
		if (targets.countLiving() == 0)
		{
			_levelText.text = "SUCCESS!";
			FlxTween.singleVar(_levelText, "alpha", 1, 2, { complete: onWon } );
		}
	}
}