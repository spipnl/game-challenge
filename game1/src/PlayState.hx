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
	
	private var _level:TiledLevel;
	private var _player:Player;
	private var _exit:FlxSprite;
	private var _scoreText:FlxText;
	private var _status:FlxText;
	private var _coins:FlxGroup;
	private var _bullets:FlxTypedGroup<Bullet>;
	public var targets:FlxGroup;
	
	public var cannon:Cannon;
	
	override public function create():Void 
	{
		FlxG.sound.playMusic("gameloop");
		
		createFloor();
		
		_topMenu = new TopMenu();
		_topMenu.leftTitle = "SHOOT THE COINS!";
		
		//FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;
		//FlxG.debugger.visible = true;
		
		//_level = new TiledLevel("assets/levels/level.tmx");
		_level = new TiledLevel("assets/levels/level_base.tmx");
		//_level = new FlxTilemap();
		//_level.loadMap(Assets.getText("assets/level.csv"), GraphicAuto, 0, 0, FlxTilemap.AUTO);
		
		//_level.loadMap(Assets.getText("assets/levels/level_base.txt"), GraphicAuto, 8, 8, FlxTilemap.AUTO);
		
		// Add tilemaps
		add(_level.foregroundTiles);
		
		// Draw coins first
		targets = new FlxGroup();
		add(targets);
		
		// Load player objects
		_level.loadObjects(this);
		
		// Add background tiles after adding level objects, so these tiles render on top of player
		add(_level.backgroundTiles);
		
		// Create the _level _exit
		_exit = new FlxSprite(35 * 8 + 1 , 25 * 8);
		_exit.makeGraphic(14, 16, FlxColor.GREEN);
		_exit.exists = false;
		add(_exit);
		
		// Create _player
		_player = new Player(700, FlxG.height - 96);
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
		
		_bullets = cannon.getBullets();
		
		//add(_status);
		add(_topMenu);
	}
	
	private function createFloor():Void
	{
		// CREATE FLOOR TILES
		var	FloorImg = Assets.getBitmapData("assets/images/fresh_snow.png");
		var ImgWidth = FloorImg.width;
		var ImgHeight = FloorImg.height;
		var i = 0; 
		var j = 0; 
		
		while ( i <= FlxG.width )  
		{
			while ( j <= FlxG.height )
			{
				var spr = new FlxSprite(i, j, FloorImg);
				add(spr);
				j += ImgHeight;
			}
			i += ImgWidth;
			j = 0;
		}
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
		
		FlxG.collide(_level.foregroundTiles, _player);
		FlxG.collide(_level.foregroundTiles, _bullets);
		FlxG.overlap(_bullets, targets, hitTarget);
		
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
	}
	
	private function hitTarget(Bullet:FlxObject, Target:FlxObject):Void
	{
		Target.kill();
		FlxG.sound.play("pling");
		_topMenu.leftTitle = "SCORE: " + (targets.countDead() * 100);
		
		if (targets.countLiving() == 0)
		{
			FlxG.camera.shake(0.01, 0.2, FlxG.resetState);
			//_status.text = "Find the exit";
			//_exit.exists = true;
		}
	}
}