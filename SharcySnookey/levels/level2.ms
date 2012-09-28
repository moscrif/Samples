class Level2 : Level
{
    function init()
    {
        this.tileMap = _2;
        this.playerX = 1;
        this.playerY = 5;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level3());
    }
}