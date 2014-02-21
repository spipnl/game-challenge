package ;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class MenuButton extends FlxButton
{
	public function new(X:Float, Y:Float, Width:Int, Height:Int, ?Label:String, ?OnClick:Void -> Void) 
	{
		super(X, Y, Label, OnClick);
		makeGraphic(Width, Height, 0xFF3498DB);
		var labelOffsetNormal:FlxPoint = new FlxPoint(0, 8);
		var labelOffsetPress:FlxPoint = new FlxPoint(0, 9);
		labelOffsets = [labelOffsetNormal, labelOffsetNormal, labelOffsetPress];
		label.color = 0xFFFFFF;
	}
}