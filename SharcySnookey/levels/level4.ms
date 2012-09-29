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
        // 1st
        var ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 6;
        ai.row = 2;

        // 2nd
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 6;
        ai.row = 15;

        // 3th
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 11;
        ai.row = 2;

        // 4th
        ai = new AI();
        ai.direction = #down;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 11;
        ai.row = 21;

        // 5th
        ai = new AI();
        ai.direction = #up;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 16;
        ai.row = 10;

        // 6th
        ai = new AI();
        ai.direction = #up;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 16;
        ai.row = 20;
        
        // 5th
        ai = new AI();
        ai.direction = #up;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 21;
        ai.row = 2;

        // 6th
        ai = new AI();
        ai.direction = #up;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 21;
        ai.row = 21;
    }
}