package popup;

#if android
import extension.admob.AdMob;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.Lib;
import openfl.net.URLRequest;
import spipnl.Settings;

/**
 * Died popup
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Died extends Popup
{
    private var _playerSad:FlxSprite;
    private var _diedText:FlxText;
    private var _scoreLabels:FlxText;
    private var _scoreText:FlxText;
    private var _resetButton:MenuButton;
    
    override public function create()
    {
        _enterFrom = Popup.ENTER_FROM_TOP;
        _showCloseButton = false;
        
        super.create();
        
        _playerSad = new FlxSprite();
        _playerSad.loadGraphic(Assets.getBitmapData("images/player-sad.png"));
        _playerSad.x = (_container.width - _playerSad.width) * 0.5;
        _playerSad.y = 50;
        
        _diedText = new FlxText(0, 200, _containerBackground.width);
        _diedText.font = "fonts/FredokaOne-Regular.ttf";
        _diedText.alignment = "center";
        _diedText.color = 0xFFFFFF;
        _diedText.size = 32;
        _diedText.text = "YOU DIED";
        
        _scoreLabels = new FlxText(50, 260, _containerBackground.width - 100);
        _scoreLabels.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2, 1);
        _scoreLabels.font = "fonts/FredokaOne-Regular.ttf";
        _scoreLabels.alignment = "left";
        _scoreLabels.color = 0xA06D3D;
        _scoreLabels.size = 30;
        _scoreLabels.text = "Score:";
        _scoreLabels.text += "\nHigh score:";
        
        _scoreText = new FlxText(50, 260, _containerBackground.width - 100);
        _scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2, 1);
        _scoreText.font = "fonts/FredokaOne-Regular.ttf";
        _scoreText.alignment = "right";
        _scoreText.color = 0xA06D3D;
        _scoreText.size = 30;
        _scoreText.text = Std.string(Reg.score);
        _scoreText.text += "\n" + Reg.highScore;
        
        if (Reg.score > Reg.highScore) {
            Reg.highScore = Reg.score;
            _scoreText.text += "\nNEW HIGH SCORE!";
        }
        Reg.saveData();
        
        _resetButton = new MenuButton("Close", onReturnToMain);
        
        _resetButton.x = (_container.width - _resetButton.width) * 0.5;
        _resetButton.y = _container.height - _resetButton.height - 30;
        
        _container.add(_playerSad);
        _container.add(_diedText);
        _container.add(_scoreLabels);
        _container.add(_scoreText);
        _container.add(_resetButton);
        
        show();
    }
    /**
     * When the popup has opened
     * 
     * @param    tween
     */
    override private function onOpenTweenFinished(tween:FlxTween):Void
    {
        #if android
        if(AdMob.hasCachedInterstitial(Settings.settings.get('admob-interstitial-id'))) {
            AdMob.showInterstitial(Settings.settings.get('admob-interstitial-id'));
        }
        #end
    }
    
    /**
     * When the user clicks the reset button, return to the main menu
     */
    private function onReturnToMain():Void
    {
        FlxG.resetState();
    }
}
