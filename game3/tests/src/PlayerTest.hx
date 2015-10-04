package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import Player;

class PlayerTest 
{
    var player:Player;
    
    public function new() 
    {
    }
    
    @BeforeClass
    public function beforeClass():Void
    {
    }
    
    @AfterClass
    public function afterClass():Void
    {
    }
    
    @Before
    public function setup():Void
    {
        player = new Player();
    }
    
    @After
    public function tearDown():Void
    {
    }
    
    @Test
    public function testShoot():Void
    {
        Assert.areEqual(3, player.getNumberOfBullets());
        player.shoot();
        Assert.areEqual(2, player.getNumberOfBullets());
    }
}