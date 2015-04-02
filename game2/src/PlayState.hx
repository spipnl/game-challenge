package; 

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.dynamics.CollisionArbiter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import openfl.Assets;

/**
 * Initial PlayState
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class PlayState extends FlxNapeState
{
	public var background:Background;
	public var levelGenerator:LevelGenerator;
	public var enemies:FlxSpriteGroup;
	public var floorBody:Body;
	public var floorShape:Polygon;
	public var player:Player;
	public var quicksand:Quicksand;
	public var cirt:FlxShapeCircle;
	
	public var hud:HUD;
	
	private var gameSpeed:Int = 100;
	
	//public var ball:Body;
	
	override public function create():Void 
	{
		FlxG.debugger.visible = true;
		//napeDebugEnabled = true;
		
		super.create();
		
		FlxNapeState.space.gravity.setxy(0, 2000);
		
		floorBody = new Body(BodyType.KINEMATIC);
		floorBody.shapes.add(new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 2)));
		
		var CB_FLOOR:CbType = new CbType();
		floorBody.cbTypes.add(CB_FLOOR);
		
		floorBody.space = FlxNapeState.space;
		
		FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON, null, 0);
		FlxG.camera.setBounds(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.bgColor = 0xffd0f4f7;
		
		FlxNapeState.space.listeners.add(new PreListener(
			InteractionType.COLLISION,
			Platform.CB_PLATFORM_ONE_WAY,
			Player.CB_PLAYER,
			onPlayerStartsCollidingWithOneWayPlatform
		));
		
		FlxNapeState.space.listeners.add(new InteractionListener(
			CbEvent.ONGOING,
			InteractionType.COLLISION,
			Player.CB_PLAYER,
			CB_FLOOR,
			onPlayerIsCollidingWithFloor
		));
		
		FlxNapeState.space.listeners.add(new InteractionListener(
			CbEvent.ONGOING,
			InteractionType.COLLISION,
			Player.CB_PLAYER,
			Platform.CB_PLATFORM,
			onPlayerIsCollidingWithPlatform
		));
		
		FlxNapeState.space.listeners.add(new InteractionListener(
			CbEvent.END,
			InteractionType.COLLISION,
			Player.CB_PLAYER,
			Platform.CB_PLATFORM,
			onPlayerStopsCollidingWithPlatform
		));
		
		hud = new HUD(0, 0);
        
		background = new Background();
        
        levelGenerator = new LevelGenerator();
        
		enemies = new FlxSpriteGroup();
		
		player = new Player(FlxG.width * 0.5, FlxG.height * 0.5);
		
        background.gameSpeed = gameSpeed;
        levelGenerator.gameSpeed = gameSpeed;
        
        // Add all sprites in correct z-index order
		add(background);
		add(background.smallClouds);
		add(enemies);
		add(player);
		add(levelGenerator);
		add(levelGenerator.platforms);
		add(background.bigClouds);
		add(hud);
        
		enemies = generateEnemies(enemies, 5);
	}
	
	private function generateEnemies(enemies:FlxSpriteGroup, amount:Int):FlxSpriteGroup
	{
		for (i in 0...amount)
		{
			var enemy:Enemy = new Enemy(0, 0);
			enemy.kill();
			enemies.add(enemy);
		}
		
		return enemies;
	}
    
	private function onPlayerStartsCollidingWithOneWayPlatform(cb:PreCallback):PreFlag
	{
		var colArb:CollisionArbiter = cb.arbiter.collisionArbiter;
		
		if (colArb.normal.y >= 0)
		{
			return PreFlag.IGNORE;
		}
		else
		{
			return PreFlag.ACCEPT;
		}
	}
	
	private function onPlayerIsCollidingWithFloor(i:InteractionCallback):Void
	{
		var colArb:CollisionArbiter = cast(i.arbiters.at(0));
		
		player.canJump = colArb.normal.y < 0;
	}
	
	private function onPlayerIsCollidingWithPlatform(i:InteractionCallback):Void
	{
		var platform:Platform = cast(i.int2, Body).userData.data;
		platform.health -= 2;
		
		var colArb:CollisionArbiter = cast(i.arbiters.at(0));
		
		player.canJump = colArb.normal.y < 0;
		
		if (colArb.normal.y >= 0 && platform.breakable)
		{
			platform.health -= 30;
		}
	}
	
	private function onPlayerStopsCollidingWithPlatform(i:InteractionCallback):Void
	{
		player.canJump = false;
	}
	
	override public function update():Void
	{
		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
        
		Reg.score += Std.int(gameSpeed / 100);
		hud.score = Reg.score;
		
        if (enemies.countLiving() < 5) {
            var enemy:Enemy = cast(enemies.getFirstDead());
            enemy.body.position.x = Math.random() * FlxG.width;
            enemy.body.position.y = -100;
            enemy.body.angularVel = Math.random() > 0.5 ? 20 : -20;
            enemy.revive();
        }
        
		super.update();
	}
}
