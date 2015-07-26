package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;
import spipnl.Settings;
//import extension.gpg.GooglePlayGames;

/**
 * Initial Game
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class GameClass extends FlxGame
{
	public function new()
	{
		Settings.loadXml("texts/local.xml");
		
		GAnalytics.startSession(Settings.settings.get('googleanalytics'));
		GAnalytics.trackEvent("Player", "Started", "The Game");
		
		Reg.loadData();
		//GooglePlayGames.init(true);
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 540;
		var ratioY:Float = stageHeight / 960;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		var fps:Int = 60;
		
		FlxG.sound.cache('menu-music');
		FlxG.sound.cache('game-music');
		
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), SpipnlSplashState, ratio, fps, fps);
	}
}
