package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import flixel.FlxGame;
import flixel.FlxG;

/**
 * First game of the Game Challenge
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Main extends Sprite 
{
	private var _game:GameClass;
	
	/**
	 * Entry point
	 */
	public static function main():Void
	{	
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	/**
	 * Initialize the Game
	 */
	private function init(?E:Event):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		initialize();
		
		_game = new GameClass();
		addChild(_game);
	}
	
	/**
	 * Setup of the stage
	 */
	private function initialize():Void 
	{
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyDown);
	}
	
	/**
	 * Listen to keydowns to switch to different states
	 *
	 * @param Event 		The KeyboardEvent
	 */
	private function onKeyDown(event:KeyboardEvent ):Void
	{
		#if android
		event.stopImmediatePropagation();
		#end
		if ( event.keyCode == 27 ) // 27 == esc == android back key
		{
			var currentState = _game.getCurrentState();
			var stateType = Type.getClassName(Type.getClass(currentState));
			
			switch (stateType)
			{
				case "MainMenuState":
					#if !(flash || js)
					GAnalytics.trackEvent("Player", "Stopped", "The Game");
					GAnalytics.stopSession();
					Lib.exit();
					#end
				case "AboutState":
					FlxG.switchState(new MainMenuState(false));
				case "PlayState":
					FlxG.switchState(new MainMenuState());
				case "FinishedState":
					FlxG.switchState(new MainMenuState());
			}
		}
	}
}
