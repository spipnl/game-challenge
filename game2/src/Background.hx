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
	private var _gameSpeed:Float = 100;
	
	private var _bigCloudInterval:Int = 150;
	private var _smallCloudInterval:Int = 50;
	
	private var _startBackground:FlxSprite;
	private var _bigClouds:FlxSpriteGroup;
	private var _smallClouds:FlxSpriteGroup;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		_startBackground = new FlxSprite(0, 0, "images/colored_desert.png");
		
		_bigClouds = new FlxSpriteGroup();
		for (i in 0...10) {
			var bigCloud:FlxSprite = new FlxSprite();
			bigCloud.loadGraphic("images/bigCloud.png");
			bigCloud.kill();
			_bigClouds.add(bigCloud);
		}
		
		_smallClouds = new FlxSpriteGroup();
		for (i in 0...20) {
			var smallCloud:FlxSprite = new FlxSprite();
			smallCloud.loadGraphic("images/smallCloud.png");
			smallCloud.kill();
			_smallClouds.add(smallCloud);
		}
		
		add(_startBackground);
		add(_bigClouds);
		add(_smallClouds);
	}
	
	override public function update():Void
	{
		if (_startBackground.y < FlxG.height) {
			_startBackground.y += _gameSpeed / 150;
		}
		
		var newBigCloud:Bool = true;
		_bigClouds.forEachAlive(function(bigCloud:FlxSprite) {
			bigCloud.y += bigCloud.velocity.y;
			if (bigCloud.y < _bigCloudInterval) {
				newBigCloud = false;
			}
			if (!bigCloud.isOnScreen()) {
				bigCloud.kill();
			}
		});
		
		if (newBigCloud) {
			var bigCloud:FlxSprite = _bigClouds.recycle(FlxSprite);
			bigCloud.x = FlxG.width * Math.random() - bigCloud.width * 0.5;
			bigCloud.y = -bigCloud.height;
			bigCloud.velocity.y = _gameSpeed / (70 + 30 * Math.random());
		}
		
		var newSmallCloud:Bool = true;
		_smallClouds.forEachAlive(function(smallCloud:FlxSprite) {
			smallCloud.y += smallCloud.velocity.y;
			if (smallCloud.y < _smallCloudInterval) {
				newSmallCloud = false;
			}
			if (!smallCloud.isOnScreen()) {
				smallCloud.kill();
			}
		});
		
		if (newSmallCloud) {
			var smallCloud:FlxSprite = _smallClouds.recycle(FlxSprite);
			smallCloud.x = FlxG.width * Math.random() - smallCloud.width * 0.5;
			smallCloud.y = -smallCloud.height;
			smallCloud.velocity.y = _gameSpeed / (50 + 20 * Math.random());
		}
	}
}
