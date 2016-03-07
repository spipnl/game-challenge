package;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.text.FlxText;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxNapeState
{
    private var _player:Player;
    
    override public function create():Void 
    {   
        super.create();
        
        FlxG.cameras.bgColor = 0xFFDDDDDD;
        FlxNapeState.space.worldLinearDrag = 5;
        
        init();
        
        FlxG.debugger.visible = true;
        FlxG.log.redirectTraces = true;
        napeDebugEnabled = true;
    }
    
    private function init():Void
    {
        _player = new Player();
        add(_player);
    }
}
