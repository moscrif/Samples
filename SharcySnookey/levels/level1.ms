class Level1 : Level
{
    function init()
    {
        this.tileMap = _1;
        this.playerX = 60;
        this.playerY = 9*40/*tile height*/ + 20;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level2());
    }
}