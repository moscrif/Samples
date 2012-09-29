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

        // 1st
        var ai = new AI();
        ai.direction = #up;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 15;
        ai.row = 7;

        // 2nd
        ai = new AI();
        ai.direction = #up;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 15;
        ai.row = 20;

        // 3th
        ai = new AI();
        ai.direction = #right;
        // place AI
        ai.level = this;
        ai.tiled = this.tiled;
        ai.column = 18;
        ai.row = 10;
    }
}