package ;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.Assets;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class Lava extends FlxSpriteGroup
{
	private var lavaOffset:Float = 1;
	private var lavaWidth:Float;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		createLavaSprites();
	}
	
	/**
	 * Create the lava sprites with a repeating image
	 */
	private function createLavaSprites():Void
	{
		var	lavaImg:BitmapData = Assets.getBitmapData("images/lava.png");
		var imgWidth = lavaImg.width;
		var imgHeight = lavaImg.height;
		var i = 0;
		
		while (i <= FlxG.width + lavaImg.width)  
		{
			var spr = new FlxSprite(i, 0, lavaImg);
			add(spr);
			
			i += imgWidth;
		}
		
		lavaWidth = imgWidth;
	}
	
	override public function update():Void
	{
		x -= 0.5;
		
		if (x <= - lavaWidth) {
			x = 0;
		}
	}
}