class Level : Scene
{
    function init()
    {
        this._bg = Bitmap.fromFile("app://bg.png");

        this.tiled = new TiledLayer({
            columns     : 32,
            rows        : 23,
            image       : "app://tiles.png",
            tileWidth   : 40,
            tileHeight  : 40,
        });

        for (var i = 0; i < this.tileMap.length; i++) {
            this.tiled.setCellDirect(i, this.tileMap[i]);
        }
        this.add(this.tiled);

        this.score = 0.0;

        this._createPaints();
        this._createPlayer();
        this.enemies = new Array();
        this.createEnemies();
    }

    function draw(canvas)
    {
        canvas.drawBitmap(this._bg, 0, 0);

        super.draw(canvas);

        // draw score
        canvas.drawText("score: " + this.score.toString(), System.width / 20, System.height / 20, this._scorePaint);
    }

    function pointerPressed(x, y)
    {
        // call parents pointer pressed function
        super.pointerPressed(x, y);

        if (y < System.width / 4)
            this._player.direction= #up;
        else if (y > 3*System.height / 4)
            this._player.direction= #down;
        else if (x > 3*System.width / 4)
            this._player.direction= #right;
        else if (x < System.width / 4)
            this._player.direction= #left;
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);
        this._player.direction = #stop;
    }

    function _createPaints()
    {
        this._scorePaint = new Paint();
        this._scorePaint.textSize = System.height / 25;
        this._scorePaint.color = 0xFFFFFFFF;
    }

    function _createPlayer()
    {
        this._player = new Player();
        this._player.tiled = this.tiled;
        // player start position
        this._player.x = this.playerX;
        this._player.y = this.playerY;
        this._player.level = this;
        this.add(this._player);
    }

    // protected
    function createEnemies()
    {
    }
}