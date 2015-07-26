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
    private var _background:FlxSprite;
	
    private var _container:FlxSpriteGroup;
    private var _containerBackground:FlxSprite;
    private var _closeButton:FlxButton;
    
	public static inline var ENTER_FROM_LEFT:String = 'left';
	public static inline var ENTER_FROM_TOP:String = 'top';
    
    private var _enterFrom:String = ENTER_FROM_LEFT;
	private var _showCloseButton:Bool = true;
    
    override public function create()
    {
        _container = new FlxSpriteGroup();
        
		_background = new FlxSprite();
		_background.width = FlxG.width;
		_background.height = FlxG.height;
		_background.makeGraphic(FlxG.width, FlxG.height);
		_background.alpha = 0;
		
		_containerBackground = new FlxSprite();
		_containerBackground.loadGraphic(Assets.getBitmapData("images/popup-bg.png"));
        
        _container.add(_containerBackground);
		
		if (_showCloseButton) {
			_closeButton = new FlxButton(0, 0, '', close);
			_closeButton.loadGraphic(Assets.getBitmapData("images/close.png"));
			
			_closeButton.x = _containerBackground.width - 25 - _closeButton.width;
			_closeButton.y = 25;
			
			_container.add(_closeButton);
		}
        
		add(_background);
        add(_container);
    }
    
    private function show()
    {
		FlxTween.tween(_background, { alpha: 0.5 }, 0.2);
		
        if (_enterFrom == ENTER_FROM_LEFT) {
            _container.x = -_containerBackground.width;
            _container.y = (FlxG.height - _containerBackground.height) * 0.3;
            
            FlxTween.tween(_container, { x: (FlxG.width - _containerBackground.width) * 0.5 }, 0.5, { startDelay: 0.2, type: FlxTween.ONESHOT, ease: FlxEase.elasticOut } );
        } else if (_enterFrom == ENTER_FROM_TOP) {
            _container.x = (FlxG.width - _containerBackground.width) * 0.5;
            _container.y = -_containerBackground.height;
            
            FlxTween.tween(_container, { y: (FlxG.height - _containerBackground.height) * 0.3 }, 1.5, { startDelay: 0.2, type: FlxTween.ONESHOT, ease: FlxEase.backOut } );
        }
    }
    
    override public function close()
    {
        if (_enterFrom == ENTER_FROM_LEFT) {
            FlxTween.tween(_container, {x: FlxG.width}, 0.1, {type: FlxTween.ONESHOT});
        } else if (_enterFrom == ENTER_FROM_TOP) {
            FlxTween.tween(_container, {y: FlxG.height}, 0.1, {type: FlxTween.ONESHOT});
        }
		
		FlxTween.tween(_background, { alpha: 0 }, 0.2, {complete: onCloseTweenFinished});
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
