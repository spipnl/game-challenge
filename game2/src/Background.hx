package ;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class Background extends FlxSpriteGroup
{
	private var _startBackground:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		_startBackground = new FlxSprite(0, 0, "images/colored_desert.png");
		
		add(_startBackground);
	}
	
	override public function update():Void
	{
		if (_startBackground.y < FlxG.height) {
			_startBackground.y += 1;
		}
	}
}
