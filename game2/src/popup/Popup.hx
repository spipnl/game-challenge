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
    
	public static inline var ENTER_FROM_LEFT:String = 'left';
	public static inline var ENTER_FROM_TOP:String = 'top';
    
    private var _enterFrom:String;
    
	public function new() 
	{
        super(0x66000000);
	}
    
    override public function create()
    {
        // Default from left
        _enterFrom = ENTER_FROM_LEFT;
        
        _container = new FlxSpriteGroup();
        
		_background = new FlxSprite();
		_background.loadGraphic(Assets.getBitmapData("images/popup-bg.png"));
        
		_closeButton = new FlxButton(0, 0, '', close);
		_closeButton.loadGraphic(Assets.getBitmapData("images/close.png"));
        
        _closeButton.x = _background.width - 25 - _closeButton.width;
        _closeButton.y = 25;
        
        _container.add(_background);
        _container.add(_closeButton);
        add(_container);
    }
    
    private function show()
    {
        if (_enterFrom == ENTER_FROM_LEFT) {
            _container.x = -_background.width;
            _container.y = (FlxG.height - _background.height) * 0.3;
            
            FlxTween.tween(_container, { x: (FlxG.width - _background.width) * 0.5 }, 0.5, { type: FlxTween.ONESHOT, ease: FlxEase.elasticOut } );
        } else if (_enterFrom == ENTER_FROM_TOP) {
            _container.x = (FlxG.width - _background.width) * 0.5;
            _container.y = -_background.height;
            
            FlxTween.tween(_container, { y: (FlxG.height - _background.height) * 0.3 }, 0.5, { type: FlxTween.ONESHOT, ease: FlxEase.elasticOut } );
        }
    }
    
    override public function close()
    {
        if (_enterFrom == ENTER_FROM_LEFT) {
            FlxTween.tween(_container, {x: FlxG.width}, 0.1, {type: FlxTween.ONESHOT, complete: onCloseTweenFinished});
        } else if (_enterFrom == ENTER_FROM_TOP) {
            FlxTween.tween(_container, {y: FlxG.height}, 0.1, {type: FlxTween.ONESHOT, complete: onCloseTweenFinished});
        }
    }
	
	/**
	 * When the popup has moved out of the screen, close the popup
	 * 
	 * @param	tween
	 */
	private function onCloseTweenFinished(tween:FlxTween):Void
	{
        super.close();
	}
}
