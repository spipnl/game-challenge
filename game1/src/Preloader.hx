package ;

import flixel.system.FlxPreloader;

/**
 * ...
 * @author spipnl (Jip Spinnewijn)
 */
class Preloader extends FlxPreloader
{

	public function new() 
	{
		super();
		
		minDisplayTime = 20;
		
		/*
		_leftTitleText = new FlxText(10, 6, titleWidth);
		_leftTitleText.font = "assets/fonts/OpenSans-Bold.ttf";
		_leftTitleText.alignment = "left";
		_leftTitleText.color = 0xecf0f1;
		_leftTitleText.size = 16;
		*/
	}
	
}