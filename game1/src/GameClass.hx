package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;
import haxe.xml.Fast;
import openfl.Assets;

/**
 * Initial Game
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class GameClass extends FlxGame
{
	@:isVar public var totalNumberOfBullets(get, set):Int;

	public function new()
	{
		// Load the local settings xml and fetch the Google Analytics code
		var xml = new Fast(Xml.parse(Assets.getText("texts/local.xml")).firstElement());
		
		GAnalytics.startSession(xml.node.googleanalytics.att.value);
		GAnalytics.trackEvent("Player", "Started", "The Game");
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 800;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		var fps:Int = 60;
		totalNumberOfBullets = 4;
		
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MainMenuState, ratio, fps, fps);
	}
	
	/**
	 * Return the current active state
	 *
	 * @return FlxState
	 */
	public function getCurrentState():FlxState
	{
		return _state;
	}

	public function get_totalNumberOfBullets():Int
	{
		return totalNumberOfBullets;
	}
	
	public function set_totalNumberOfBullets(NumberOfBullets:Int):Int
	{
		totalNumberOfBullets = NumberOfBullets;

		return totalNumberOfBullets;
	}
}