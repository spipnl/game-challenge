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
 * Third game of the Game Challenge
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Main extends Sprite 
{
    private var _inited:Bool;
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
            stage.addEventListener(Event.RESIZE, resize);
        } else {
            initialize();
        }
    }
    
    private function resize(e) 
    {
        initialize();
    }
    
    /**
     * Setup of the stage
     */
    private function initialize():Void 
    {
        if (_inited) return;
        _inited = true;
        
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        
        FlxG.log.redirectTraces = true;
        _game = new GameClass();
        addChild(_game);
    }
}
