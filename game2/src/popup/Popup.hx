package popup;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import openfl.Assets;

/**
 * A poup with image background
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Popup extends FlxSpriteGroup
{
	public function new() 
	{
		super(0, 0);
        
		var background:FlxSprite = new FlxSprite();
		background.loadGraphic(Assets.getBitmapData("images/popup-bg.png"));
		//background.makeGraphic(FlxG.width, 50, FlxColor.BLACK);
        
		var closeButton:FlxButton = new FlxButton(0, 0, '', onClose);
		closeButton.loadGraphic(Assets.getBitmapData("images/close.png"));
        
        closeButton.x = background.width - 20 - closeButton.width;
        closeButton.y = 20;
        
        add(background);
        add(closeButton);
        
        x = -background.width;
        y = (FlxG.height - background.height) * 0.3;
        
		FlxTween.tween(this, {x: (FlxG.width - background.width) * 0.5}, 0.5, {type: FlxTween.ONESHOT, ease: FlxEase.elasticOut});
	}
    
    private function onClose()
    {
		FlxTween.tween(this, {x: FlxG.width}, 0.3, {type: FlxTween.ONESHOT, ease: FlxEase.expoOut});
    }
}