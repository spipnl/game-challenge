package popup;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
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
class Popup extends FlxSubState
{
    private var _container:FlxSpriteGroup;
    private var _background:FlxSprite;
    private var _closeButton:FlxButton;
    
	public function new() 
	{
        super(0x66000000);
	}
    
    override public function create()
    {
        _container = new FlxSpriteGroup();
        
		_background = new FlxSprite();
		_background.loadGraphic(Assets.getBitmapData("images/popup-bg.png"));
        
		_closeButton = new FlxButton(0, 0, '', onClose);
		_closeButton.loadGraphic(Assets.getBitmapData("images/close.png"));
        
        _closeButton.x = _background.width - 25 - _closeButton.width;
        _closeButton.y = 25;
        
        _container.add(_background);
        _container.add(_closeButton);
        add(_container);
    }
    
    private function show()
    {
        _container.x = -_background.width;
        _container.y = (FlxG.height - _background.height) * 0.3;
        
		FlxTween.tween(_container, {x: (FlxG.width - _background.width) * 0.5}, 0.5, {type: FlxTween.ONESHOT, ease: FlxEase.elasticOut});
    }
    
    private function onClose()
    {
		FlxTween.tween(_container, {x: FlxG.width}, 0.1, {type: FlxTween.ONESHOT, complete: onCloseTweenFinished});
    }
	
	/**
	 * When the popup has moved out of the screen, close the popup
	 * 
	 * @param	tween
	 */
	private function onCloseTweenFinished(tween:FlxTween):Void
	{
        close();
	}
}
