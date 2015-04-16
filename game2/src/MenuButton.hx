package ;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

/**
 * A button with custom font and image background
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MenuButton extends FlxButton
{
	public function new(?Label:String, ?OnClick:Void -> Void) 
	{
		super(0, 0, Label, OnClick);
        loadGraphic(Assets.getBitmapData("images/menubutton.png"));
        
		var labelOffsetNormal:FlxPoint = new FlxPoint(0, 10);
		var labelOffsetPress:FlxPoint = new FlxPoint(0, 12);
		labelOffsets = [labelOffsetNormal, labelOffsetNormal, labelOffsetPress];
		label.font = "fonts/FredokaOne-Regular.ttf";
		label.color = 0xFFFFFF;
		label.size = 40;
	}
    
	override public function update():Void
	{
        if (status == FlxButton.PRESSED) {
            offset.y = -2;
        } else {
            offset.y = 0;
        }
        
        super.update();
    }
}