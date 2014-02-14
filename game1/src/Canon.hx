package;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;

/**
 * The Canon
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Canon extends FlxGroup
{
	private var _canon:FlxSprite;
	private var _poolSize:UInt = 10;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super();
		
		_canon = new FlxSprite(X, Y);
		_canon.makeGraphic(10, 20, FlxColor.CRIMSON);
		add(_canon);
		
		_bullets = new FlxTypedGroup<Bullet>(_poolSize);
		for (i in 0..._poolSize)
		{
			var bullet:Bullet = new Bullet();
			bullet.kill();
			_bullets.add(bullet);
		}
		add(_bullets);
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.mouse.justPressed) {
			shootBullet();
		}
	}
	
	private function shootBullet():Void
	{
		var bullet:Bullet = _bullets.recycle(Bullet);
		bullet.init(_canon.x, _canon.y);
		trace('bang!');
	}
}