package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxState
{
	private var _topMenu:TopMenu;
	
	private static var _justDied:Bool = false;
	
	private var _level:FlxTilemap;
	private var _player:Player;
	private var _exit:FlxSprite;
	private var _scoreText:FlxText;
	private var _status:FlxText;
	private var _coins:FlxGroup;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	private var _canon:Canon;
	
	override public function create():Void 
	{
		_topMenu = new TopMenu();
		
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		//FlxG.debugger.visible = true;
		
		_level = new FlxTilemap();
		_level.loadMap(Assets.getText("assets/level.csv"), GraphicAuto, 0, 0, FlxTilemap.AUTO);
		add(_level);
		
		_canon = new Canon(80, FlxG.height - 100);
		add(_canon);
		
		// Create the _level _exit
		_exit = new FlxSprite(35 * 8 + 1 , 25 * 8);
		_exit.makeGraphic(14, 16, FlxColor.GREEN);
		_exit.exists = false;
		add(_exit);
		
		// Create _player
		_player = new Player(500, FlxG.height - 96);
		add(_player);
		
		_scoreText = new FlxText(2, 2, 80, "SCORE: ");
		_scoreText.setFormat(null, 8, FlxColor.WHITE, null, FlxText.BORDER_NONE, FlxColor.BLACK);
		//add(_scoreText);
		
		_status = new FlxText(FlxG.width - 160 - 2, 2, 160, "Collect coins.");
		_status.setFormat(null, 8, FlxColor.WHITE, "right", FlxText.BORDER_NONE, FlxColor.BLACK);
		
		FlxG.camera.setBounds(0, 0, 970, 500, true); //Note, the player does weird things when he walks off screen.
		//FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
		
		if (_justDied)
		{
			_status.text = "Aww, you died!";
		}
		
		_bullets = _canon.getBullets();
		
		//add(_status);
		add(_topMenu);
	}
	
	override public function update():Void 
	{
		_player.acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			_player.acceleration.x = -_player.maxVelocity.x * 4;
		}
		
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			_player.acceleration.x = _player.maxVelocity.x * 4;
		}
		
		if (FlxG.keys.anyJustPressed(["SPACE", "UP", "W"]) && _player.isTouching(FlxObject.FLOOR))
		{
			_player.velocity.y = -_player.maxVelocity.y / 2;
		}
		
		var zoom:Float = FlxG.camera.zoom;
		if (FlxG.mouse.wheel > 0) {
			zoom += 0.1;
		}
		if (FlxG.mouse.wheel < 0) {
			zoom -= 0.1;
		}
		FlxG.camera.zoom = zoom;
		
		super.update();
		
		FlxG.collide(_level, _player);
		FlxG.collide(_level, _bullets);
		FlxG.overlap(_bullets, _player, win);
		
		if (_player.y > FlxG.height)
		{
			_justDied = true;
			FlxG.resetState();
		}
	}
	
	private function win(Exit:FlxObject, Player:FlxObject):Void
	{
		_status.text = "Yay, you won!";
		_scoreText.text = "SCORE: 5000";
		_player.kill();
		//FlxG.resetState();
		
		FlxG.camera.shake(0.05, 0.5, FlxG.resetState);
	}
	
	private function getCoin(Coin:FlxObject, Player:FlxObject):Void
	{
		Coin.kill();
		_scoreText.text = "SCORE: " + (_coins.countDead() * 100);
		
		if (_coins.countLiving() == 0)
		{
			_status.text = "Find the exit";
			_exit.exists = true;
		}
	}
}