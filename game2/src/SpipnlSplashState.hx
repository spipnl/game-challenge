package; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import openfl.Assets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * spip.nl splash screen
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class SpipnlSplashState extends FlxState
{
	private var _logo:FlxSprite;
    
	public function new()
	{
        super();
    }
    
	override public function create():Void 
	{
        
		#if FLX_NO_DEBUG
        
        bgColor = 0xFF33363B;
        
		_logo = new FlxSprite(0, 0, "images/spipnl-splash.png");
        
        _logo.x = (FlxG.width - _logo.width) * 0.5;
        _logo.y = (FlxG.height - _logo.height) * 0.5;
        
        add(_logo);
        
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true, function() {
            var timer = new FlxTimer();
            timer.start(1, function(Timer:FlxTimer):Void {
                FlxG.camera.fade(FlxColor.WHITE, 0.5, false, function() {
                    FlxG.switchState(new PlayState());
                });
            }, 1);
		});
        
		#else
        
        FlxG.switchState(new PlayState());
        
        #end
	}
}
