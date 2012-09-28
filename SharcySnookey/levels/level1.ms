class Level1 : Level
{
    function init()
    {
        this.tileMap = _1;
        this.playerX = 1;
        this.playerY = 9;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level2());
    }
}