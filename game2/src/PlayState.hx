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
import flixel.util.FlxColor;
import popup.Popup;

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
    public var mainMenu:MainMenu;
	
	private var gameSpeed:Int = 100;
	private var gameStarted:Bool = false;
	
	override public function create():Void 
	{
		FlxG.debugger.visible = true;
		//napeDebugEnabled = true;
		
		super.create();
		
		FlxNapeState.space.gravity.setxy(0, 2000);
		
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
		
		hud = new HUD();
        
		background = new Background();
        
        levelGenerator = new LevelGenerator();
        
		enemies = new FlxSpriteGroup();
		
		player = new Player(290, 740);
		
        background.gameSpeed = gameSpeed;
        levelGenerator.gameSpeed = gameSpeed;
        
        mainMenu = new MainMenu();
        
        // Add all sprites in correct z-index order
		add(background);
		add(background.smallClouds);
		add(enemies);
		add(player);
		add(levelGenerator);
		add(levelGenerator.platforms);
		add(background.bigClouds);
        add(mainMenu);
		add(hud);
        
		enemies = generateEnemies(enemies, 5);
        
		FlxG.camera.fade(FlxColor.WHITE, 0.5, true);
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
	
	private function onPlayerIsCollidingWithPlatform(i:InteractionCallback):Void
	{
		var platform:Platform = cast(i.int2, Body).userData.data;
        platform.isStanding();
		
		var colArb:CollisionArbiter = cast(i.arbiters.at(0));
		
        // When the player starts 'standing' on the platform, reset the number op jumps
        if (colArb.normal.y < 0) {
            player.resetJumps();
            player.isTouchingPlatform = true;
        }
		
		if (colArb.normal.y >= 0 && platform.breakable)
		{
            platform.isStomped();
		}
	}
	
	private function onPlayerStopsCollidingWithPlatform(i:InteractionCallback):Void
	{
        // Set 'standing' on the platform to false, to prevent unwilling resetting of jumps
        player.isTouchingPlatform = false;
	}
    
    private function start():Void
    {
        Reg.score = 0;
        
        gameStarted = true;
        
        remove(mainMenu);
        levelGenerator.start();
        background.start();
        player.start();
        hud.start();
    }
    
    private function onLost():Void
    {
        gameSpeed = 0;
        
		FlxG.camera.fade(FlxColor.WHITE, 5, false, function() {
            FlxG.switchState(new PlayState());
        });
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
        
        if (mainMenu.isStarted()) {
            if (!gameStarted) {
                start();
            }
            
            Reg.score += Std.int(gameSpeed / 100);
            hud.score = Reg.score;
            
            //if (enemies.countLiving() < 5) {
                //var enemy:Enemy = cast(enemies.getFirstDead());
                //enemy.body.position.x = Math.random() * FlxG.width;
                //enemy.body.position.y = -100;
                //enemy.body.angularVel = Math.random() > 0.5 ? 20 : -20;
                //enemy.revive();
            //}
                    
            if (player.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height) 
            {
                onLost();
            }
        }
        
        if (mainMenu.showAbout()) {
            var popup:Popup = new Popup();
            add(popup);            
        }
        
		super.update();
	}
}
