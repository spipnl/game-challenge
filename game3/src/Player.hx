package;

import flixel.addons.nape.FlxNapeSprite;

class Player extends FlxNapeSprite
{
    private var numberOfBullets:Int;
    
    public function new() 
    {
        init();
        
        super();
    }
    
    private function init()
    {
        numberOfBullets = 3;
    }
    
    public function getNumberOfBullets()
    {
        return numberOfBullets;
    }
    
    public function shoot()
    {
        numberOfBullets--;
    }
}