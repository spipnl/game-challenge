package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;

/**
 * Initial Game
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class GameClass extends FlxGame
{
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 800;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		var fps:Int = 60;
		
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MainMenuState, ratio, fps, fps);
		
		#if android
		FlxG.sound.add("cannonshot");
		FlxG.sound.add("gameloop");
		FlxG.sound.add("pling");
		#end
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
}