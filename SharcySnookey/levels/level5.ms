class Level5 : Level
{
    function init()
    {
        this.tileMap = _5;
        this.playerX = 60;
        this.playerY = 12*40/*tile height*/ + 20;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level6());
    }

   function createEnemies()
   {
        // first
        var ai = new AI();
        ai.direction = #left;
        // place AI
        ai.x = 25*40+20;
        ai.y = 7*40 + 20;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // second
        ai = new AI();
        ai.direction = #left;
        // place AI
        ai.x = 28*40+20;
        ai.y = 16*40 + 20;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
    }
}