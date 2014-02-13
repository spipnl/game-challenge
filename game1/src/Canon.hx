package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;

/**
 * The Canon
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class Canon extends FlxSprite
{
	private var _poolSize:UInt = 10;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(10, 20, FlxColor.CRIMSON);
		
		_bullets = new FlxTypedGroup<Bullet>(_poolSize);
		for (i in 0..._poolSize)
		{
			//_bullets.add(new Bullet().kill());
		}
		trace('bang!');
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
		bullet.init(x, y);
		trace('bang!');
	}
}