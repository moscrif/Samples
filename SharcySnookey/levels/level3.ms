class Level3 : Level
{
    function init()
    {
        this.tileMap = _3;
        this.playerX = 60;
        this.playerY = 5*40/*tile height*/ + 20;
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
        ai.x = 15*40+20;
        ai.y = 3*40;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // second
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.x = 15*40+20;
        ai.y = 15*40;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
   }
}