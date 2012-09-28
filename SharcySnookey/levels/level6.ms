class Level6 : Level
{
    function init()
    {
        this.tileMap = _6;
        this.playerX = 1;
        this.playerY = 9;
        super.init();
    }

    function nextLevel()
    {
        this.add(new Message({text: "Finish!!!", scene : this}));
    }

   function createEnemies()
   {
        // first
        var ai = new AI();
        ai.direction = #up;
        // place AI
        ai.x = 15*40+20;
        ai.y = 7*40 + 20;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // second
        ai = new AI();
        ai.direction = #up;
        // place AI
        ai.x = 15*40+20;
        ai.y = 20*40 + 20;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // third
        ai = new AI();
        ai.direction = #right;
        // place AI
        ai.x = 18*40+20;
        ai.y = 10*40 + 20;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
    }
}