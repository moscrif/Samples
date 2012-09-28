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
   }

   function createEnemies()
   {
        // first
        var ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 10;
        ai.row = 3;

       /* // second
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.column = 10;
        ai.row = 15;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);*/
   }
}