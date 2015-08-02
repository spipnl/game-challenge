package popup;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import openfl.Assets;
import openfl.Lib;
import openfl.net.URLRequest;

/**
 * About popup
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class About extends Popup
{
    private var _aboutText:FlxText;
    private var _kenneyText:FlxText;
    private var _logoSpipnl:FlxButton;
    private var _logoGithub:FlxButton;
    private var _logoKenney:FlxButton;
    
    override public function create()
    {
        super.create();
        
        _aboutText = new FlxText(80, 60, _containerBackground.width - 160);
        
        _aboutText.font = "fonts/FredokaOne-Regular.ttf";
        _aboutText.alignment = "left";
        _aboutText.color = 0xFFFFFF;
        _aboutText.size = 18;
        _aboutText.text = "Roll yourself to the top in this thrilling sky adventure in the second game of my game challenge.\n\nClick on the logo’s to visit my site or the GitHub repository with the source of all my games";
        
        _logoSpipnl = new FlxButton(0, 0, '', onSpipnl);
        _logoSpipnl.loadGraphic(Assets.getBitmapData("images/logo-spipnl.png"));
        _logoGithub = new FlxButton(0, 0, '', onGithub);
        _logoGithub.loadGraphic(Assets.getBitmapData("images/logo-github.png"));
        
        _logoSpipnl.x = _containerBackground.width * 0.5 - _logoSpipnl.width - 30;
        _logoGithub.x = _containerBackground.width * 0.5 + 30;
        
        _logoSpipnl.y =
        _logoGithub.y = _containerBackground.height - 240;
        
        _kenneyText = new FlxText(80, _containerBackground.height - 70, 125);
        
        _kenneyText.font = "fonts/FredokaOne-Regular.ttf";
        _kenneyText.alignment = "left";
        _kenneyText.color = 0xFFFFFF;
        _kenneyText.size = 18;
        _kenneyText.text = "Graphics by:";
        
        _logoKenney = new FlxButton(0, 0, '', onKenney);
        _logoKenney.loadGraphic(Assets.getBitmapData("images/logo-kenney.png"));
        _logoKenney.x = _kenneyText.x + _kenneyText.width;
        _logoKenney.y = _kenneyText.y;
        
        _container.add(_aboutText);
        _container.add(_logoSpipnl);
        _container.add(_logoGithub);
        
        _container.add(_kenneyText);
        _container.add(_logoKenney);
        
        show();
    }
    
    /**
     * When the users clicks on the spip.nl logo, launch the browser with spip.nl url
     */
    private function onSpipnl():Void
    {
        Lib.getURL(new URLRequest("http://spip.nl/"));
    }
    
    /**
     * When the users clicks on the GitHub logo, launch the browser with the github repo url
     */
    private function onGithub():Void
    {
        Lib.getURL(new URLRequest("https://github.com/spipnl/game-challenge/tree/master/game2"));
    }
    
    /**
     * When the users clicks on the Kenney logo, launch the browser with kenney.nl url
     */
    private function onKenney():Void
    {
        Lib.getURL(new URLRequest("http://kenney.nl/"));
    }
}
