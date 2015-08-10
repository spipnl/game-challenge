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
import flixel.tweens.FlxTween;
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
import popup.About;
import popup.Died;
import popup.Popup;
import spipnl.Settings;

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
    
    private var gameStarted:Bool = false;
    
    @:isVar public var gameSpeed(get, set):Int;
    
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
            CbEvent.BEGIN,
            InteractionType.COLLISION,
            Player.CB_PLAYER,
            Platform.CB_PLATFORM,
            onPlayerStartsCollidingWithPlatform
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
        
        FlxNapeState.space.listeners.add(new PreListener(
            InteractionType.COLLISION,
            Player.CB_PLAYER,
            PowerUp.CB_POWER_UP,
            onPlayerStartsCollidingWithPowerUp
        ));
        
        FlxNapeState.space.listeners.add(new InteractionListener(
            CbEvent.ONGOING,
            InteractionType.COLLISION,
            Player.CB_PLAYER,
            PowerUp.CB_POWER_UP,
            onPlayerIsCollidingWithPowerUp
        ));
        
        FlxNapeState.space.listeners.add(new InteractionListener(
            CbEvent.BEGIN,
            InteractionType.COLLISION,
            Player.CB_PLAYER,
            Enemy.CB_ENEMY,
            onPlayerStartsCollidingWithEnemy
        ));
        
        hud = new HUD();
        
        background = new Background();
        
        levelGenerator = new LevelGenerator();
        
        enemies = new FlxSpriteGroup();
        
        player = new Player(290, 740);
        
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
        FlxG.sound.playMusic("menu-music", 0.5);
        
        gameSpeed = 100;
    }
    
    public function get_gameSpeed():Int
    {
        return gameSpeed;
    }
    
    public function set_gameSpeed(GameSpeed:Int):Int
    {
        gameSpeed = GameSpeed;
        
        background.gameSpeed = gameSpeed;
        levelGenerator.gameSpeed = gameSpeed;
        
        return gameSpeed;
    }
    
    public function back():Void
    {
        var popupType = Type.getClassName(Type.getClass(subState));
        if (popupType == 'popup.About')
        {
            var popup:Popup = cast(subState);
            popup.close();
        } 
        else
        {
            #if !(flash || js)
            Lib.exit();
            #end
        }
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
    
    private function onPlayerStartsCollidingWithPlatform(i:InteractionCallback):Void
    {
        var platform:Platform = cast(i.int2, Body).userData.data;
        var colArb:CollisionArbiter = cast(i.arbiters.at(0));
        
        // When the player starts 'standing' on the platform, reset the number op jumps
        if (colArb.normal.y < 0)
        {
            player.resetJumps();
            player.isTouchingPlatform = true;
        }
        
        if (colArb.normal.y >= 0 && platform.breakable)
        {
            platform.isStomped();
        }
    }
    
    private function onPlayerIsCollidingWithPlatform(i:InteractionCallback):Void
    {
        var platform:Platform = cast(i.int2, Body).userData.data;
        platform.isStanding();
    }
    
    private function onPlayerStopsCollidingWithPlatform(i:InteractionCallback):Void
    {
        // Set 'standing' on the platform to false, to prevent unwilling resetting of jumps
        player.isTouchingPlatform = false;
    }
    
    private function onPlayerStartsCollidingWithPowerUp(cb:PreCallback):PreFlag
    {
        return PreFlag.IGNORE;
    }
    
    private function onPlayerIsCollidingWithPowerUp(i:InteractionCallback):Void
    {
        var powerUp:PowerUp = cast(i.int2, Body).userData.data;
        player.addPowerUp(powerUp);
        powerUp.destroy();
    }
    
    private function onPlayerStartsCollidingWithEnemy(i:InteractionCallback):Void
    {
        player.losePowerUp();
    }
    
    private function start():Void
    {
        Reg.score = 0;
        Reg.numberOfPlays += 1;
        Reg.saveData();
        
        GAnalytics.trackEvent("Player", "Began", "Game " + Reg.numberOfPlays);
        
        gameStarted = true;
        
        remove(mainMenu);
        levelGenerator.start();
        background.start();
        player.start();
        hud.start();
        
        FlxTween.tween(FlxG.sound.music, {volume: 0}, 1, {complete: onPlayGameMusic});
    }
    
    private function onPlayGameMusic(tween:FlxTween):Void
    {
        FlxG.sound.playMusic("game-music", 0.5);
    }
    
    private function onLost():Void
    {
        gameStarted = false;
        player.kill();
        gameSpeed = 0;
        GAnalytics.trackEvent("Player", "Died", "Game " + Reg.numberOfPlays, Reg.score);
        
        openSubState(new Died());
        FlxTween.tween(FlxG.sound.music, {volume: 0}, 2);
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
        
        if (mainMenu.isStarted() && !gameStarted)
        {
            start();
        }
        
        if (gameStarted)
        {
            Reg.score += Std.int(gameSpeed / 100);
            hud.score = Reg.score;
            
            // Only add a new power up when the player has fewer than 3 power ups
            if (player.getPowerUps().length < 3 && Reg.score % 1000 == 0)
            {
                var extraJump:PowerUp = new PowerUp(Math.random() * FlxG.width, -100);
                extraJump.body.angularVel = Math.random() > 0.5 ? 20 : -20;
                add(extraJump);
            }
            
            // Add enemy up when the score can be divided by 1000
            if (Reg.score % 200 == 0)
            {
                var enemy:Enemy = cast(enemies.getFirstDead());
                enemy.body.position.x = Math.random() * FlxG.width;
                enemy.body.position.y = -100;
                enemy.body.angularVel = Math.random() > 0.5 ? 20 : -20;
                enemy.revive();
            }
            
            if (player.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height) 
            {
                player.kill();
            }
            
            hud.setPowerUps(player.getPowerUps());
            
            if (gameSpeed < 150 && Reg.score % 100 == 0)
            {
                gameSpeed++;
            }
            
            if (!player.alive) {
                onLost();
            }
            
            // Add enemy up when the score can be divided by 1000
            if (Reg.score % 500 == 0)
            {
                levelGenerator.goToNextLevel();
            }
        }
        
        if (mainMenu.showAbout())
        {
            openSubState(new About());
        }
        
        super.update();
    }
}
