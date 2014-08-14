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
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

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
	
	private var _helpArrow:FlxSprite;
	private var _helpText:FlxText;
	
	private var _explosion:FlxEmitterExt;
	
	private var _currentMap:Int;
	
	public function new(currentMap)
	{
		_currentMap = currentMap;
		super();
	}
	
	override public function create():Void 
	{
		GAnalytics.trackScreen("Level " + _currentMap);
		
		createBackground();
		
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
		
		// Add helpers for the first level
		if (_currentMap == 1) {
			addHelpArrow();
		}
		
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
			FlxTween.tween(_levelText, {alpha: 0}, 1);
		});
	}
	
	/**
	 * Create an arrow pointing downwards to the cannon with instruction text
	 */
	private function addHelpArrow():Void
	{
		// Get the position of the cannon and place the arrow above it.
		var cannonPosition = cannon.getDragCenter();
		_helpArrow = new FlxSprite(cannonPosition.x - 15, cannonPosition.y - 100);
		
		_helpArrow.makeGraphic(30, 60, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawPolygon(_helpArrow, [
			new FlxPoint(_helpArrow.width * 0.1, 0), 
			new FlxPoint(_helpArrow.width * 0.9, 0),
			new FlxPoint(_helpArrow.width * 0.7, _helpArrow.height * 0.7),
			new FlxPoint(_helpArrow.width,  _helpArrow.height * 0.7),
			new FlxPoint(_helpArrow.width * 0.5,  _helpArrow.height),
			new FlxPoint(0, _helpArrow.height * 0.7),
			new FlxPoint(_helpArrow.width * 0.3, _helpArrow.height * 0.7),
			new FlxPoint(_helpArrow.width * 0.1, 0)],
			0xFF84494A,  {color: FlxColor.WHITE, thickness: 2}
		);
		
		_helpText = new FlxText(_helpArrow.x - 100 + _helpArrow.width * 0.5, _helpArrow.y - 50, 200);
		_helpText.font = "fonts/OpenSans-Bold.ttf";
		_helpText.alignment = "center";
		_helpText.color = 0x84494a;
		_helpText.size = 22;
		_helpText.text = "DRAG & RELEASE!";
		_helpText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 3, 1);
		
		add(_helpText);
		add(_helpArrow);
	}
	
	/**
	 * Create the default background with a repeating image
	 */
	private function createBackground():Void
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
				bullet.kill();
			}
		});

		_topTitleBar.leftTitle = "Power: " + (cannon.getPower());
		_topTitleBar.rightTitle = "Bullets left: " + (cannon.getBulletsLeft());
		
		// Hide helpers when the users starts dragging
		if (cannon.getDragging() && _helpArrow != null) {
			FlxTween.tween(_helpArrow, {alpha: 0}, 0.5);
			FlxTween.tween(_helpText, {alpha: 0}, 0.5);
		}
		
		if (_bullets.countLiving() == 0 && cannon.getBulletsLeft() == 0 && targets.countLiving() != 0) {
			_levelText.text = "YOU LOSE";
			GAnalytics.trackEvent("Player", "Lost", "Level " + _currentMap);
			FlxTween.tween(_levelText, {alpha: 1}, 1, {complete: onLost});
		}
		
		super.update();
	}
	
	private function onLost(tween:FlxTween):Void
	{
		FlxG.camera.fade(FlxColor.WHITE, 0.5, false, function() {
			FlxG.switchState(new MainMenuState());
		});
	}
	
	private function onWon(tween:FlxTween):Void
	{
		_currentMap += 1;
		
		FlxG.camera.fade(FlxColor.WHITE, 0.5, false, function() {
			if (_currentMap > 10) {
				FlxG.switchState(new FinishedState());
			} else {
				FlxG.switchState(new PlayState(_currentMap));
			}
		});
	}
	
	/**
	 * Create an explosion at given position
	 *
	 * @param X 		The x position of the explosion
	 * @param Y 		The y position of the explosion
	 */
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
	
	/**
	 * Action when a bullet hits a target
	 *
	 * @param Bullet		The bullet
	 * @param Target 		The target
	 */
	private function hitTarget(Bullet:FlxObject, Target:FlxObject):Void
	{
		explode(Target.x + Target.width * 0.5, Target.y + Target.height * 0.5);
		Target.kill();
		FlxG.sound.play("pling");
		
		if (targets.countLiving() == 0)
		{
			_levelText.text = "SUCCESS!";
			GAnalytics.trackEvent("Player", "Won", "Level " + _currentMap);
			FlxTween.tween(_levelText, {alpha: 1}, 1, { complete: onWon } );
		}
	}
}