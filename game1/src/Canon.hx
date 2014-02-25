package;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxAngle;
import flash.display.Sprite;
import flixel.util.FlxPoint;
import flash.display.BlendMode;

using flixel.util.FlxSpriteUtil;

/**
 * The Canon
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Canon extends FlxGroup
{
	private var _canon:FlxSprite;
	private var _shootDrag:FlxSprite;
	private var _poolSize:UInt = 10;
	private var _bullets:FlxTypedGroup<Bullet>;
	private var _dragging:Bool;
	private var _dragCenter:FlxPoint;
	
	/**
	 * Helper Sprite object to draw canon's range graphic
	 */
	private static var DRAG_SPRITE:Sprite = null;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super();
		
		_canon = new FlxSprite(X, Y);
		_canon.makeGraphic(20, 30, FlxColor.CRIMSON);
		_dragCenter = _canon.getMidpoint();
		
		_bullets = new FlxTypedGroup<Bullet>(_poolSize);
		for (i in 0..._poolSize)
		{
			var bullet:Bullet = new Bullet();
			bullet.kill();
			_bullets.add(bullet);
		}
		
		_shootDrag = new FlxSprite(Std.int(_canon.x + _canon.width * 0.5), Std.int(_canon.y + _canon.height * 0.5));
		_shootDrag.makeGraphic(1, 1);
		_shootDrag.antialiasing = true;
		_shootDrag.visible = false;
		
		add(_bullets);
		add(_canon);
		add(_shootDrag);
		
		_dragging = false;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.mouse.justPressed)
		{
			if (FlxMath.pointInCoordinates(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), Std.int(_canon.x), Std.int(_canon.y), Std.int(_canon.width), Std.int(_canon.height)))
			{
				_dragging = true;
			}
		}
		
		if (_dragging)
		{
			
			var source:FlxPoint = _dragCenter;
			var mouse:FlxPoint = FlxG.mouse.getWorldPosition();
			// getAngle return angle with 0 degree point up, but we need the angle start from pointing right
			var deg:Float = FlxAngle.getAngle(source, mouse)-90;
			//var groundPoint:FlxPoint = new FlxPoint(source.x + (ground-source.y)/Math.tan(deg*FlxAngle.TO_RAD), ground);
			var length:Float = FlxMath.getDistance(source, mouse);
			
			var range:Int = Std.int(length);
			if (range < 1)
			{
				range = 1;
			}
			_shootDrag.setPosition(source.x, source.y);
			_shootDrag.makeGraphic(2, 2, 0xFF444444 );
			_shootDrag.angle = deg;
			_shootDrag.scale.set(length / _shootDrag.pixels.width, 1);
			_shootDrag.origin.set(0, _shootDrag.pixels.height / 2);
			_shootDrag.visible = true;
			
			
			/*
			//_shootDrag.angle = 50;
			_shootDrag.setPosition(_dragCenter.x - range, _dragCenter.y - range);
			_shootDrag.makeGraphic(range * 2, range * 2, 0x88FF0000 );
			
			DRAG_SPRITE = new Sprite();
			DRAG_SPRITE.graphics.beginFill( 0xFFFFFF );
			DRAG_SPRITE.graphics.lineStyle(3, 0xFF000000);
			//DRAG_SPRITE.graphics.drawCircle(range, range, range);
			//DRAG_SPRITE.graphics.moveTo(0, 0);
			//DRAG_SPRITE.graphics.lineTo(_dragCenter.x, _dragCenter.y);
			DRAG_SPRITE.graphics.moveTo(range, range);
			DRAG_SPRITE.graphics.lineTo(source.x - mouse.x, source.y - mouse.y);
			DRAG_SPRITE.graphics.lineTo(range * 1.5, range * 0.5);
			DRAG_SPRITE.graphics.lineTo(range * 0.5, range * 0.5);
			DRAG_SPRITE.graphics.lineTo(range, range);
			DRAG_SPRITE.graphics.endFill();

			_shootDrag.pixels.draw(DRAG_SPRITE);
			
			#if !(cpp || neko || js)
			_shootDrag.blend = BlendMode.INVERT;
			#else
			_shootDrag.alpha = 0.3;
			#end
			
			_shootDrag.visible = true;
			*/
		}
		
		if (FlxG.mouse.justReleased && _dragging)
		{
			_dragging = false;
			_shootDrag.visible = false;
			shootBullet(Std.int(_dragCenter.x - FlxG.mouse.x), Std.int(_dragCenter.y - FlxG.mouse.y));
		}
	}
	
	private function shootBullet(X:Int, Y:Int):Void
	{
		var bullet:Bullet = _bullets.recycle(Bullet);
		bullet.init(_canon.x, _canon.y);
		bullet.shoot(X, Y);
	}
	
	public function getBullets():FlxTypedGroup<Bullet>
	{
		return _bullets;
	}
}