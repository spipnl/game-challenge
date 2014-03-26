package ;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class MenuButton extends FlxButton
{
	public function new(X:Float, Y:Float, Width:Int, Height:Int, ?Label:String, ?OnClick:Void -> Void) 
	{
		super(X, Y, Label, OnClick);
		makeGraphic(Width, Height, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(this, 0, 0, Width, Height, 8, 8, 0xFF3B8DBD);
		
		var labelOffsetNormal:FlxPoint = new FlxPoint(0, 8);
		var labelOffsetPress:FlxPoint = new FlxPoint(0, 9);
		labelOffsets = [labelOffsetNormal, labelOffsetNormal, labelOffsetPress];
		label.font = "fonts/OpenSans-Bold.ttf";
		label.color = 0xFFFFFF;
		label.size = 18;
		label.text = label.text.toUpperCase();
	}
}