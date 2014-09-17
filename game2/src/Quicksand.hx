package ;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import openfl.Assets;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class Quicksand extends FlxSpriteGroup
{
	private var quicksand1:FlxSprite;
	private var quicksand2:FlxSprite;
	private var quicksand3:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		quicksand1 = new FlxSprite(0, FlxG.height, "images/quicksand.png");
		add(quicksand1);
		quicksand2 = new FlxSprite(0, FlxG.height, "images/quicksand.png");
		add(quicksand2);
		quicksand3 = new FlxSprite(0, FlxG.height, "images/quicksand.png");
		add(quicksand3);
		
		FlxTween.tween(quicksand1, {y: FlxG.height - 80}, 0.9, {type: FlxTween.PINGPONG, ease: FlxEase.quadIn, complete: onQuicksandComplete});
		FlxTween.tween(quicksand2, {y: FlxG.height - 80}, 0.9, {type: FlxTween.PINGPONG, ease: FlxEase.quadIn, complete: onQuicksandComplete, startDelay: 0.6});
		FlxTween.tween(quicksand3, {y: FlxG.height - 80}, 0.9, {type: FlxTween.PINGPONG, ease: FlxEase.quadIn, complete: onQuicksandComplete, startDelay: 1.2});
		
	}
	
	/**
	 * When the quicksand tween has finished a complete loop, push the first sprite (finished) at the end of the members array
	 * 
	 * @param	tween
	 */
	private function onQuicksandComplete(tween:FlxTween):Void
	{
		if (tween.backward) {
			members.push(members.shift());
		}
	}
}
