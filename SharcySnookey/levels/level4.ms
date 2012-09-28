class Level4 : Level
{
    function init()
    {
        this.tileMap = _4;
        this.playerX = 1;
        this.playerY = 21;
        super.init();
    }

    function nextLevel()
    {
        game.push(new Level5());
    }

    function createEnemies()
    {
        // first
        var ai = new AI();
        ai.direction = #down;
        // place AI
        ai.x = 6*40+20;
        ai.y = 3*40;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // second
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.x = 11*40+20;
        ai.y = 5*40;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // third
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.x = 16*40+20;
        ai.y = 16*40;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
        // fourth
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.x = 21*40+20;
        ai.y = 15*40;
        ai.level = this;
        ai.tiled = this.tiled;
        this.add(ai);
        this.enemies.push(ai);
    }
}