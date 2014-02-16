package;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flash.display.Sprite;
import flixel.util.FlxPoint;
import flash.display.BlendMode;

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
			var range = Std.int(Math.abs(_dragCenter.x - FlxG.mouse.x));
			if (range < 1)
			{
				range = 1;
			}
			trace(range);
			//_shootDrag.angle = 50;
			_shootDrag.setPosition(_dragCenter.x - range, _dragCenter.y - range);
			_shootDrag.makeGraphic(range * 2, range * 2, FlxColor.TRANSPARENT );
			
			DRAG_SPRITE = new Sprite();
			DRAG_SPRITE.graphics.beginFill( 0xFFFFFF );
			DRAG_SPRITE.graphics.drawCircle(range, range, range);
			DRAG_SPRITE.graphics.endFill();

			_shootDrag.pixels.draw(DRAG_SPRITE);
			
			#if !(cpp || neko || js)
			_shootDrag.blend = BlendMode.INVERT;
			#else
			_shootDrag.alpha = 0.3;
			#end
			
			_shootDrag.visible = true;
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
		trace('bang!');
	}
	
	public function getBullets():FlxTypedGroup<Bullet>
	{
		return _bullets;
	}
}