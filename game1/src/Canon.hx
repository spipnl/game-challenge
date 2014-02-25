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
 * The Canon
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Canon extends FlxGroup
{
	private var _canon:FlxSprite;
	private var _canonBarrel:FlxSprite;
	private var _canonBarrelTween:FlxTween;
	private var _shootDrag:FlxSprite;
	private var _shootDragTween:FlxTween;
	private var _poolSize:UInt = 10;
	private var _bullets:FlxTypedGroup<Bullet>;
	private var _dragging:Bool;
	private var _dragCenter:FlxPoint;
	private var _orgScaleX:Float = 1;
	
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
		_canonBarrel = new FlxSprite(_dragCenter.x - 5, _dragCenter.y - 20);
		_canonBarrel.makeGraphic(30, 20, FlxColor.CHARCOAL);
		_canonBarrel.origin.set(5, _canonBarrel.pixels.height * 0.5);
		
		_shootDrag = new FlxSprite(_dragCenter.x, _canonBarrel.y + _canonBarrel.pixels.height * 0.5);
		_shootDrag.makeGraphic(40, 40, FlxColor.SILVER);
		FlxSpriteUtil.drawRoundRect(_shootDrag, 0, 0, _shootDrag.width, _shootDrag.height, 8, 8, 0xFF2980b9);
		_shootDrag.antialiasing = true;
		_shootDrag.visible = false;
		_shootDrag.alpha = 0.5;
		
		add(_bullets);
		add(_canonBarrel);
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

			var shootPower = Math.min(8, Math.max(2, length * 0.1));

			//_shootDrag.setPosition(source.x, source.y);
			_shootDrag.angle = deg;
			//_shootDrag.scale.set(shootPower * 10 / _shootDrag.pixels.width, shootPower);
			//_shootDrag.makeGraphic(Std.int(shootPower * 10), Std.int(shootPower * 2), 0xFF000000);
			
			DRAG_SPRITE = new Sprite();
			DRAG_SPRITE.graphics.beginFill( 0xFFFFFF );
			DRAG_SPRITE.graphics.moveTo(0, _shootDrag.height * 0.5);
			DRAG_SPRITE.graphics.lineTo(_shootDrag.width, 0);
			DRAG_SPRITE.graphics.lineTo(_shootDrag.width, _shootDrag.height);
			DRAG_SPRITE.graphics.lineTo(0, _shootDrag.height * 0.5);
			DRAG_SPRITE.graphics.endFill();

			//_shootDrag.pixels.draw(DRAG_SPRITE);
			
			_shootDrag.origin.x = 0;
			//_shootDrag.origin.y = _shootDrag.height * 0.5;
			//FlxSpriteUtil.drawRoundRect(_shootDrag, 0, 0, _shootDrag.width, _shootDrag.height, 8, 8, 0xFF2980b9);
			//_shootDrag.origin.set(0, _shootDrag.pixels.height * 0.5);
			_shootDrag.visible = true;
			/*
			if (_shootDragTween != null && _shootDragTween.active) {
				_shootDragTween.cancel();
			}
			_shootDragTween = flixel.tweens.FlxTween.angle(_shootDrag, _shootDrag.angle, deg, 0.1);
			*/
			if (_canonBarrelTween != null && _canonBarrelTween.active) {
				_canonBarrelTween.cancel();
			}
			_canonBarrelTween = FlxTween.angle(_canonBarrel, _canonBarrel.angle, deg + 180, 0.15);
		}
		
		if (FlxG.mouse.justReleased && _dragging)
		{
			_dragging = false;
			_shootDrag.visible = false;
			_orgScaleX = _canonBarrel.scale.x;
			shootBullet(Std.int(_dragCenter.x - FlxG.mouse.x), Std.int(_dragCenter.y - FlxG.mouse.y));

			//FlxTween.singleVar(_canonBarrel.scale, "x", _orgScaleX * 0.5, 0.2);
			//FlxTween.singleVar(_canonBarrel.scale, "x", _orgScaleX * 2, 5, { ease: flixel.tweens.FlxEase.bounceOut, type: FlxTween.ONESHOT, delay: 0.5});
			//FlxTween.linearMotion(_canonBarrel, _canonBarrel.x, _canonBarrel.y, _canonBarrel.x, _canonBarrel.y, 1, true, { ease: flixel.tweens.FlxEase.bounceOut, type: FlxTween.ONESHOT });
		}
	}

	private function onShotComplete(tween:FlxTween):Void
	{
		FlxTween.singleVar(_canonBarrel.scale, "x", _orgScaleX, 0.5, { ease: flixel.tweens.FlxEase.bounceOut, type: FlxTween.ONESHOT});
	}
	
	private function shootBullet(X:Int, Y:Int):Void
	{
		FlxTween.singleVar(_canonBarrel.scale, "x", _orgScaleX * 0.7, 0.1, {type: FlxTween.ONESHOT, complete: onShotComplete});

		var bullet:Bullet = _bullets.recycle(Bullet);
		bullet.init(_canonBarrel.x, _canonBarrel.y + _canonBarrel.pixels.height * 0.5);
		bullet.shoot(X, Y);
	}
	
	public function getBullets():FlxTypedGroup<Bullet>
	{
		return _bullets;
	}
}