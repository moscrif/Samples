class Level3 : Level
{
    function init()
    {
        this.tileMap = _3;
        this.playerX = 1;
        this.playerY = 4;
        super.init();
    }

   function nextLevel()
   {
        game.push(new Level4());
        game.paused = false;
   }

   function createEnemies()
   {
        // first
        var ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 15;
        ai.row = 2;

        // first
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 15;
        ai.row = 13;
   }
}