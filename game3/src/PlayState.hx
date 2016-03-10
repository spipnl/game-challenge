package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.text.FlxText;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxState
{
    private var _player:Player;
    private var _text:FlxText;
    
    override public function create():Void 
    {   
        super.create();
        FlxNapeSpace.init();
        
        FlxG.cameras.bgColor = 0xFFDDDDDD;
        FlxNapeSpace.space.worldLinearDrag = 5;
        
        init();
        
        FlxG.debugger.visible = true;
        FlxG.log.redirectTraces = true;
        FlxNapeSpace.drawDebug = true;
    }
    
    private function init():Void
    {
        _player = new Player();
        add(_player);
        
        _text = new FlxText(10, 10, 100);
        _text.color = 0xFF00AAFF;
        add(_text);
    }
    
    override public function update(elapsed:Float):Void
    {
        _text.text = Std.string(FlxG.gamepads.numActiveGamepads);
        
        super.update(elapsed);
    }
}
