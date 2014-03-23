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
import flixel.tweens.FlxTween;

using flixel.util.FlxSpriteUtil;

/**
 * The cannon
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Cannon extends FlxGroup
{
	private var _dragMargin:UInt = 20;
	private var _cannon:FlxSprite;
	private var _cannonBarrel:FlxSprite;
	private var _cannonBarrelTween:FlxTween;
	private var _shootDrag:FlxSprite;
	private var _shootDragTween:FlxTween;
	private var _poolSize:UInt = 10;
	private var _bullets:FlxTypedGroup<Bullet>;
	private var _dragging:Bool;
	private var _dragCenter:FlxPoint;
	
	/**
	 * Helper Sprite object to draw cannon's range graphic
	 */
	private static var DRAG_SPRITE:Sprite = null;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super();
		
		_cannon = new FlxSprite(X-7, Y - 19);
		_cannon.makeGraphic(30, 35, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawPolygon(_cannon, [new FlxPoint(8, 0), new FlxPoint(_cannon.width - 8, 0), new FlxPoint(_cannon.width, _cannon.height), new FlxPoint(0, _cannon.height)], 0xFF556D75,  {color: 0xFFBAB6B2, thickness: 1});
		FlxSpriteUtil.drawCircle(_cannon, _cannon.width * 0.5, 6, 3, FlxColor.GOLDEN, {color: 0xFF9A968A, thickness: 1});
		
		_dragCenter = _cannon.getMidpoint();
		_dragCenter.y = _cannon.y + 6;
		
		_bullets = new FlxTypedGroup<Bullet>(_poolSize);
		for (i in 0..._poolSize)
		{
			var bullet:Bullet = new Bullet();
			bullet.kill();
			_bullets.add(bullet);
		}
		_cannonBarrel = new FlxSprite(_dragCenter.x - 5, _dragCenter.y - 9);
		_cannonBarrel.makeGraphic(32, 18, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(_cannonBarrel, 0, 0, _cannonBarrel.width, _cannonBarrel.height, 12, 12, FlxColor.CHARCOAL);
		_cannonBarrel.origin.set(5, _cannonBarrel.pixels.height * 0.5);
		
		_shootDrag = new FlxSprite(_dragCenter.x, _dragCenter.y);
		_shootDrag.makeGraphic(5, 5, 0xFF2980b9);
		_shootDrag.antialiasing = true;
		_shootDrag.visible = false;
		_shootDrag.alpha = 0.4;
		
		add(_bullets);
		add(_cannonBarrel);
		add(_cannon);
		add(_shootDrag);
		
		_dragging = false;
	}
	
	override public function update():Void
	{
		if (FlxG.mouse.justPressed)
		{
			if (FlxMath.pointInCoordinates(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), Std.int(_cannon.x) - _dragMargin, Std.int(_cannon.y) - _dragMargin, Std.int(_cannon.width) + _dragMargin * 2, Std.int(_cannon.height) + _dragMargin * 2))
			{
				_dragging = true;
			}
		}
		
		if (_dragging)
		{
			
			var source:FlxPoint = _dragCenter;
			var mouse:FlxPoint = FlxG.mouse.getWorldPosition();
			// getAngle return angle with 0 degree point up, but we need the angle start from pointing right
			var deg:Int = Std.int(FlxAngle.getAngle(source, mouse)-90);
			//var groundPoint:FlxPoint = new FlxPoint(source.x + (ground-source.y)/Math.tan(deg*FlxAngle.TO_RAD), ground);
			var length:Float = FlxMath.getDistance(source, mouse);
			
			var range:Int = Std.int(length);
			if (range < 1)
			{
				range = 1;
			}
			
			var shootPower:Int = Std.int(Math.min(8, Math.max(2, length * 0.1)));
			
			_shootDrag.angle = deg;
			_shootDrag.scale.set(shootPower * 10 / _shootDrag.pixels.width, shootPower);
			_shootDrag.origin.set(0, _shootDrag.pixels.height * 0.5);
			_shootDrag.visible = true;
			
			if (_cannonBarrelTween != null && _cannonBarrelTween.active) {
				_cannonBarrelTween.cancel();
			}
			_cannonBarrelTween = FlxTween.angle(_cannonBarrel, _cannonBarrel.angle, deg + 180, 0.15);
		
			if (FlxG.mouse.justReleased)
			{
				_dragging = false;
				_shootDrag.visible = false;
				shootBullet(deg, shootPower);
			}
		}
		
		super.update();
	}

	private function onShotComplete(tween:FlxTween):Void
	{
		FlxTween.singleVar(_cannonBarrel.scale, "x", 1.0, 0.5, { ease: flixel.tweens.FlxEase.bounceOut, type: FlxTween.ONESHOT});
	}
	
	private function shootBullet(Deg:Int, Strength:Int):Void
	{
		FlxG.sound.play("cannonshot");
		
		FlxTween.singleVar(_cannonBarrel.scale, "x", 0.7, 0.1, { type: FlxTween.ONESHOT, complete: onShotComplete } );
		
		var bullet:Bullet = _bullets.recycle(Bullet);
		bullet.init(_cannonBarrel.x, _cannonBarrel.y + _cannonBarrel.pixels.height * 0.5);
		bullet.shoot(Deg, Strength);
	}
	
	public function getBullets():FlxTypedGroup<Bullet>
	{
		return _bullets;
	}
}