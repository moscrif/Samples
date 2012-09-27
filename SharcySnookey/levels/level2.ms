class Level2 : Level
{
    function init()
    {
        this.tileMap = _2;
        this.playerX = 60;
        this.playerY = 5*40/*tile height*/ + 20;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level3());
    }
}