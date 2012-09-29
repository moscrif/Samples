class Level5 : Level
{
    function init()
    {
        this.tileMap = _5;
        this.playerX = 1;
        this.playerY = 12;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level6());
    }

   function createEnemies()
   {

        // 1st
        var ai = new AI();
        ai.direction = #left;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 27;
        ai.row = 7;

        // 2nd
        ai = new AI();
        ai.direction = #right;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 28;
        ai.row = 16;
    }
}