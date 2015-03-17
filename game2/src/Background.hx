package ;

import flash.display.BitmapData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class Background extends FlxSpriteGroup
{	
	private var _bigCloudInterval:Int = 150;
	private var _smallCloudInterval:Int = 50;
	
	private var _startBackground:FlxSprite;
	public var bigClouds:FlxSpriteGroup;
	public var smallClouds:FlxSpriteGroup;
	
	@:isVar public var gameSpeed(get, set):Int;
    
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
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
			smallCloud.kill();
			smallClouds.add(smallCloud);
		}
		
		add(_startBackground);
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
		if (_startBackground.y < FlxG.height) {
			_startBackground.y += gameSpeed / 150;
		}
		
		var newBigCloud:Bool = true;
		bigClouds.forEachAlive(function(bigCloud:FlxSprite) {
			bigCloud.y += bigCloud.velocity.y;
			if (bigCloud.y < _bigCloudInterval) {
				newBigCloud = false;
			}
			if (!bigCloud.isOnScreen()) {
				bigCloud.kill();
			}
		});
		
		if (newBigCloud) {
			var bigCloud:FlxSprite = bigClouds.recycle(FlxSprite);
			bigCloud.x = FlxG.width * Math.random() - bigCloud.width * 0.5;
			bigCloud.y = -bigCloud.height;
			bigCloud.velocity.y = gameSpeed / (40 + 10 * Math.random());
		}
		
		var newSmallCloud:Bool = true;
		smallClouds.forEachAlive(function(smallCloud:FlxSprite) {
			smallCloud.y += smallCloud.velocity.y;
			if (smallCloud.y < _smallCloudInterval) {
				newSmallCloud = false;
			}
			if (!smallCloud.isOnScreen()) {
				smallCloud.kill();
			}
		});
		
		if (newSmallCloud) {
			var smallCloud:FlxSprite = smallClouds.recycle(FlxSprite);
			smallCloud.x = FlxG.width * Math.random() - smallCloud.width * 0.5;
			smallCloud.y = -smallCloud.height;
			smallCloud.velocity.y = gameSpeed / (60 + 20 * Math.random());
		}
	}
}
