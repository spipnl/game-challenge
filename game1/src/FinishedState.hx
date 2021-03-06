package; 

import flixel.effects.particles.FlxEmitterExt;
import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;
import flash.display.Sprite;

using flixel.util.FlxSpriteUtil;

/**
 * Finished state when the user completes the game
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class FinishedState extends FlxState
{
	private var _topTitleBar:TitleBar;
	
	private var _finishedText:FlxText;
	private var _bulletCountText:FlxText;
	
	private var _buttons:FlxSpriteGroup;
	private var _buttonsBG:FlxSprite;
	private var _logo:FlxSprite;
	private var _backButton:MenuButton;
	
	private var _buttonsContainerWidth:Int = 400;
	private var _buttonsContainerHeight:Int = 250;
	
	private var _buttonWidth:Int = 300;
	private var _buttonHeight:Int = 44;

	private var _frameCounter:Int = 0;
	private var _targetCount:Int = 0;
	
	private var _explosion:FlxEmitterExt;
	
	override public function create():Void 
	{
		GAnalytics.trackScreen("Finished");
		
		createBackground();
		
		_topTitleBar = new TitleBar();
		_topTitleBar.middleTitle = "Congratulations!";
		
		bgColor = 0xFFbdc3c7;
		_buttons = new FlxSpriteGroup((FlxG.width - _buttonsContainerWidth) * 0.5,  (FlxG.height - _buttonsContainerHeight) * 0.5);
		_buttonsBG = new FlxSprite(0, 0);
		_buttonsBG.makeGraphic(_buttonsContainerWidth, _buttonsContainerHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(_buttonsBG, 0, 0, _buttonsBG.width, _buttonsBG.height, 8, 8, 0xFFFFFFFF);
		
		_backButton = new MenuButton((_buttonsContainerWidth - _buttonWidth) * 0.5, _buttonsContainerHeight - _buttonHeight - 25, _buttonWidth, _buttonHeight, "Back to Main Menu", onBack);

		_finishedText = new FlxText(0, 35, _buttonsContainerWidth);
		_finishedText.font = "fonts/OpenSans-Bold.ttf";
		_finishedText.alignment = "center";
		_finishedText.color = 0x84494a;
		_finishedText.size = 22;
		_finishedText.text = "You have finished the game!";
		
		_bulletCountText = new FlxText(0, 90, _buttonsContainerWidth);
		_bulletCountText.font = "fonts/OpenSans-Bold.ttf";
		_bulletCountText.alignment = "center";
		_bulletCountText.color = 0xF576C75;
		_bulletCountText.size = 16;
		_bulletCountText.text = "Total number of bullets:\n" + Reg.bulletsFired;
		
		_buttons.add(_buttonsBG);
		_buttons.add(_finishedText);
		_buttons.add(_bulletCountText);
		_buttons.add(_backButton);
		
		add(_buttons);
		
		add(_topTitleBar);

		// Add exlposion emitter
		_explosion = new FlxEmitterExt();
		_explosion.setRotation(0, 0);
		_explosion.setMotion(0, 5, 0.2, 360, 200, 1.8);
		_explosion.makeParticles("images/particles.png", 1200, 0, true, 0);
		_explosion.setAlpha(1, 1, 0, 0);
		_explosion.gravity = 400;
		add(_explosion);
		
		FlxG.camera.fade(FlxColor.WHITE, 0.5, true);
	}
	
	/**
	 * Create the default background with a repeating image
	 */
	private function createBackground():Void
	{
		// CREATE FLOOR TILES
		var	FloorImg:BitmapData = Assets.getBitmapData("images/fresh_snow.png");
		var ImgWidth = FloorImg.width;
		var ImgHeight = FloorImg.height;
		var i = 0; 
		var j = 0; 
		
		while ( i <= FlxG.width )  
		{
			while ( j <= FlxG.height )
			{
				var spr = new FlxSprite(i, j, FloorImg);
				add(spr);
				j += ImgHeight;
			}
			i += ImgWidth;
			j = 0;
		}
	}
	
	/**
	 * When the users clicks on back to main menu, switch to main menu state
	 */
	private function onBack():Void
	{
		FlxG.switchState(new MainMenuState());
	}

	/**
	 * Create an explosion at given position
	 *
	 * @param X 		The x position of the explosion
	 * @param Y 		The y position of the explosion
	 */
	private function explode(X:Float = 0, Y:Float = 0):Void
	{
		if (_explosion.visible)
		{
			_explosion.x = X;
			_explosion.y = Y;
			_explosion.start(true, 2, 0, 300);
			_explosion.update();
		}
	}

	override public function update():Void 
	{
		_frameCounter += 1;

		if (_frameCounter >= _targetCount) {
			_frameCounter = 0;
			_targetCount = 30 + Std.int(30 * Math.random());
			// Create an explosion at a random position on the screen (50 pixels margin)
			explode(50 + Math.random() * (FlxG.width - 100), 50 + Math.random() * (FlxG.height - 100));
			FlxG.sound.play("pling");
		}

		super.update();
	}
}