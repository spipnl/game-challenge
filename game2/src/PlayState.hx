package; 

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
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
	public var platforms:FlxGroup;
	public var player:Player;
	public var cirt:FlxShapeCircle;
	
	override public function create():Void 
	{
		super.create();
		
		add(new FlxSprite(0, 0, "images/colored_desert.png"));
		
		FlxNapeState.space.gravity.setxy(0, 500);
		
		var floorBody:Body = new Body(BodyType.STATIC);
		var floorShape:Polygon = new Polygon(Polygon.rect(0, FlxG.height, FlxG.width, 1));
		floorShape.body = floorBody;
		floorBody.space = FlxNapeState.space;
		
		platforms = new FlxGroup();
		
		var platform1:Platform = new Platform(80, FlxG.height - 200);
		var platform2:Platform = new Platform(240, FlxG.height - 60);
		var platform3:Platform = new Platform(400, 300);
		platforms.add(platform1);
		platforms.add(platform2);
		platforms.add(platform3);
		
		player = new Player(FlxG.width * 0.5, FlxG.height * 0.5);
		
		add(player);
		add(platforms);
	}
	
	override public function update():Void
	{
		super.update();
	}
}