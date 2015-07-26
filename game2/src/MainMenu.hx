package; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import openfl.Assets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import popup.Popup;

/**
 * Initial MainMenu
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class MainMenu extends FlxSpriteGroup
{
    private var _isStarted:Bool = false;
    private var _showAbout:Bool = false;
    
	private var _buttonsBG:FlxSprite;
    
	private var _logo:FlxSprite;
    
	private var _startButton:MenuButton;
	private var _aboutButton:MenuButton;
	
	private var _highScoreText:FlxText;
	private var _highScoreAmountText:FlxText;
	
	private var _buttonsContainerWidth:Int = 300;
	private var _buttonsContainerHeight:Int = 520;
	
	public function new()
	{
        super((FlxG.width - _buttonsContainerWidth) * 0.5,  0);
        
		_buttonsBG = new FlxSprite(0, 0);
		_buttonsBG.makeGraphic(_buttonsContainerWidth, _buttonsContainerHeight, FlxColor.TRANSPARENT);
        
		_logo = new FlxSprite();
		_logo.loadGraphic(Assets.getBitmapData("images/menutitle.png"));
        _logo.y = -_logo.height;
		
		_startButton = new MenuButton("Start", onStart);
		_aboutButton = new MenuButton("About", onAbout);
        
        _startButton.x = (_buttonsContainerWidth - _startButton.width) * 0.5;
        _startButton.y = _buttonsContainerHeight - _startButton.height - 100;
        
        _aboutButton.x = (_buttonsContainerWidth - _aboutButton.width) * 0.5;
        _aboutButton.y = _buttonsContainerHeight - _aboutButton.height;
		
		_highScoreText = new FlxText(0, FlxG.height - 150, _buttonsContainerWidth);
		_highScoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2, 1);
		_highScoreText.font = "fonts/FredokaOne-Regular.ttf";
		_highScoreText.alignment = "center";
		_highScoreText.color = 0xA06D3D;
		_highScoreText.size = 32;
        _highScoreText.text = "High Score";
		
		_highScoreAmountText = new FlxText(0, FlxG.height - 110, _buttonsContainerWidth);
		_highScoreAmountText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2, 1);
		_highScoreAmountText.font = "fonts/FredokaOne-Regular.ttf";
		_highScoreAmountText.alignment = "center";
		_highScoreAmountText.color = 0xA06D3D;
		_highScoreAmountText.size = 44;
        _highScoreAmountText.text = Std.string(Reg.highScore);
		
		add(_buttonsBG);
        add(_logo);
		add(_startButton);
		add(_aboutButton);
		add(_highScoreText);
		add(_highScoreAmountText);
        
		FlxTween.tween(_logo, {y: 180}, 1.0, {type: FlxTween.ONESHOT, ease: FlxEase.bounceOut});
	}
	
    public function isStarted()
    {
        var result = _isStarted;
        _isStarted = false;
        
        return result;
    }
	
    public function showAbout()
    {
        var result = _showAbout;
        _showAbout = false;
        
        return result;
    }
    
	/**
	 * Create the default background
	 */
	private function createBackground():Void
	{
		var backgroundImage = Assets.getBitmapData("images/colored_desert.png");
		var bgImgWidth = backgroundImage.width;
		var bgImgHeight = backgroundImage.height;
		var bgX = (FlxG.width - bgImgWidth) * 0.5;
		var bgY = (FlxG.height - bgImgHeight) * 0.5;
		
		var backgroundSprite = new FlxSprite(bgX, bgY, backgroundImage);
		
		add(backgroundSprite);
	}
	
	private function onStart():Void
	{
        _isStarted = true;
	}
	
	private function onAbout():Void
	{
        _showAbout = true;
	}
}
