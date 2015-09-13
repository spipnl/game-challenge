package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;
import spipnl.Settings;
import ru.zzzzzzerg.linden.Flurry;
import haxe.crypto.Sha256;
//import googleAnalytics.Stats;
#if android
import extension.admob.AdMob;
import extension.admob.AdMobListener;
import extension.admob.AdMobGravity;
#end

/**
 * Initial Game
 * 
 * @author spipnl (Jip Spinnewijn)
 */
class GameClass extends FlxGame
{
    public function new()
    {
        Settings.loadXml("texts/local.xml");
        
        //Stats.init(Settings.settings.get('googleanalytics-id'), Settings.settings.get('googleanalytics-domain'));
        //Stats.trackEvent("Player", "Started", "The Game");
        
        Reg.loadData();
        
        // Generate a unique hash if not present
        if (Reg.hash == '') {
            Reg.hash = Sha256.encode(Std.string(Date.now().getSeconds() + Math.random()));
            Reg.saveData();
        }
        
        Flurry.onStartSession(Settings.settings.get('flurryanalytics-id'));
        Flurry.logEvent("Game_Start", { 'user':Reg.hash } );
        
        #if android
        AdMob.init(); // Must be called first. You may specify a test device id for iOS here.

        AdMob.cacheInterstitial(Settings.settings.get('admob-interstitial-id')); // Cache interstitial with the given id from your AdMob dashboard.
        
        AdMob.setBannerPosition(AdMobHorizontalGravity.CENTER, AdMobVerticalGravity.TOP); // All banners will appear bottom center of the screen 
        AdMob.refreshBanner(Settings.settings.get('admob-banner-id'));
        #end
        
        var stageWidth:Int = Lib.current.stage.stageWidth;
        var stageHeight:Int = Lib.current.stage.stageHeight;
        
        var ratioX:Float = stageWidth / 540;
        var ratioY:Float = stageHeight / 960;
        var ratio:Float = Math.min(ratioX, ratioY);
        
        var fps:Int = 60;
        
        FlxG.sound.cache('menu-music');
        FlxG.sound.cache('game-music');
        
        super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), SpipnlSplashState, ratio, fps, fps);
    }
}
