package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

/**
 * The Enemy
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class HUD extends FlxSpriteGroup
{
    private var _hudHeight:Int = 50;
    
	private var _scoreText:FlxText;
	private var _testText:FlxText;
	
	public var background:FlxSprite;
	
	@:isVar public var score(get, set):Int;
	@:isVar public var test(get, set):Int;

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(0, -_hudHeight);
		
		background = new FlxSprite(0, 0);
		background.alpha = 0.7;
		background.makeGraphic(FlxG.width, 50, FlxColor.BLACK);
		
		_scoreText = new FlxText(background.x + 10, background.y + 2, 200);
		_scoreText.font = "fonts/FredokaOne-Regular.ttf";
		_scoreText.alignment = "left";
		_scoreText.color = 0xFFFFFF;
		_scoreText.size = 32;
		
		_testText = new FlxText(background.x + 300, background.y + 0, 100);
		_testText.font = "fonts/FredokaOne-Regular.ttf";
		_testText.alignment = "left";
		_testText.color = 0xFFFFFF;
		_testText.size = 24;
		
		add(background);
		add(_scoreText);
		add(_testText);
	}
    
    public function start():Void
    {
		FlxTween.tween(this, {y: 0}, 0.5, {type: FlxTween.ONESHOT});
    }
	
	public function get_score():Int
	{
		return score;
	}
	
	public function set_score(Score:Int):Int
	{
		score = Score;
		_scoreText.text = Std.string(Score);
		
		return score;
	}
	
	public function get_test():Int
	{
		return test;
	}
	
	public function set_test(Test:Int):Int
	{
		test = Test;
		_testText.text = Std.string(Test);
		
		return test;
	}
}