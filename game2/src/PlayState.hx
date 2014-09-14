package; 

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
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
	public var platforms:Array<FlxNapeSprite>;
	public var floorBody:Body;
	public var floorShape:Polygon;
	public var player:Player;
	public var cirt:FlxShapeCircle;
	
	private var gameSpeed:Int = 1;
	
	override public function create():Void 
	{
		FlxG.debugger.visible = true;
		//napeDebugEnabled = true;
		
		super.create();
		
		add(new FlxSprite(0, 0, "images/colored_desert.png"));
		
		FlxNapeState.space.gravity.setxy(0, 1000);
		
		//createWalls(0, 0, FlxG.width, FlxG.height);
		
		floorBody = new Body(BodyType.KINEMATIC);
		floorBody.shapes.add(new Polygon(Polygon.rect(0, 0, -2, FlxG.height)));
		//floorBody.shapes.add(new Polygon(Polygon.rect(0, 0, FlxG.width, -2)));
		floorBody.shapes.add(new Polygon(Polygon.rect(FlxG.width, 0, 2, FlxG.height)));
		floorBody.shapes.add(new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 2)));
		
		floorBody.cbTypes.add(Platform.CB_PLATFORM);
		
		//floorBody = new Body(BodyType.KINEMATIC);
		//floorShape = new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 1));
		//floorShape.body = floorBody;
		floorBody.space = FlxNapeState.space;
		
		platforms = new Array<FlxNapeSprite>();
		
		var platform1:Platform = new Platform(80, 100);
		var platform2:Platform = new Platform(240, 300);
		var platform3:Platform = new Platform(400, 500);
		var platform4:Platform = new Platform(200, 700);
		platforms.push(platform1);
		platforms.push(platform2);
		platforms.push(platform3);
		platforms.push(platform4);
		add(platform1);
		add(platform2);
		add(platform3);
		add(platform4);
		
		player = new Player(FlxG.width * 0.5, FlxG.height * 0.5);
		
		FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON, null, 0);
		FlxG.camera.setBounds(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.bgColor = 0xffd0f4f7;
		
		add(player);
		
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
	}
	
	function onPlayerIsCollidingWithPlatform(i:InteractionCallback) 
	{
		//var player:Player = cast(i.int2, Body).userData.data;
		//var platform:Platform = cast(i.int2, Body).userData.data;
		
		var colArb:CollisionArbiter = cast(i.arbiters.at(0));
		
		player.canJump = colArb.normal.y < 0;
	}
	
	function onPlayerStopsCollidingWithPlatform(i:InteractionCallback) 
	{
		player.canJump = false;
	}
	
	override public function update():Void
	{
		for (platform in platforms) {
			
			if (platform.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height) {
				var newX = platform.width * 0.5 + (FlxG.width - platform.width) * Math.random();
				var newY = FlxG.camera.bounds.y - platform.height * 0.5;
				platform.body.position.setxy(newX, newY);
			}
		}
		
		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
		
		super.update();
	}
}