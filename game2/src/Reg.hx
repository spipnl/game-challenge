package;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
    private static var _saveData:FlxSave;
    
    /**
     * variable to hold the score
     */
    public static var score:Int = 0;
    /**
     * variable to hold the high score
     */
    public static var highScore:Int = 0;
    /**
     * variable to hold the number of plays
     */
    public static var numberOfPlays:Int = 0;
    
    public static function getSaveData()
    {
        if (_saveData == null) 
        {
            _saveData = new FlxSave();
            _saveData.bind("SaveData");
        }
        
        return _saveData;
    }
    
    public static function loadData()
    {
        var saveData:FlxSave = getSaveData();
        
        if (saveData.data.highScore != null) {
            highScore = saveData.data.highScore;
        }
        if (saveData.data.numberOfPlays != null) {
            numberOfPlays = saveData.data.numberOfPlays;
        }
    }
    
    public static function saveData()
    {
        var saveData:FlxSave = getSaveData();
        
        saveData.data.highScore = highScore;
        saveData.data.numberOfPlays = numberOfPlays;
        saveData.flush();
    }
}
