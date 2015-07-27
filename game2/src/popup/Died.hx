package popup;

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

/**
 * Died popup
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Died extends Popup
{
	private var _playerSad:FlxSprite;
    private var _diedText:FlxText;
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
        
		_scoreText = new FlxText(0, 260, _containerBackground.width);
		_scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2, 1);
		_scoreText.font = "fonts/FredokaOne-Regular.ttf";
		_scoreText.alignment = "center";
		_scoreText.color = 0xA06D3D;
		_scoreText.size = 40;
        _scoreText.text = "Score: " + Reg.score;
		
		if (Reg.score > Reg.highScore) {
			Reg.highScore = Reg.score;
			Reg.saveData();
			_scoreText.text += "\nNEW HIGH SCORE!";
		}
		
        _resetButton = new MenuButton("Close", onReturnToMain);
        
        _resetButton.x = (_container.width - _resetButton.width) * 0.5;
        _resetButton.y = _container.height - _resetButton.height - 30;
        
        _container.add(_playerSad);
        _container.add(_diedText);
        _container.add(_scoreText);
		_container.add(_resetButton);
		
        show();
    }
    
	/**
	 * When the user clicks the reset button, return to the main menu
	 */
	private function onReturnToMain():Void
	{
		FlxG.resetState();
	}
}
