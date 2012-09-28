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
        this._createControls();
    }

    function draw(canvas)
    {
        canvas.drawBitmap(this._bg, 0, 0);

        super.draw(canvas);

        // draw score
        canvas.drawText("score: " + this.score.toString(), System.width / 20, System.height / 20, this._scorePaint);
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
        this._player.column = this.playerX;
        this._player.row = this.playerY;
        this._player.level = this;
    }

    function pointerReleased()
    {
        this._player.direction = #stop;
    }

    function _createControls()
    {
        var scale = System.width*1.0 / 800;
        var (width, h) = Bitmap.getSize("app://up.png");
        width *= scale;

        var up = new ImageButton({
            image   : "app://up.png",
            x       : System.width - 2*width,
            y       : System.height - 2*width,
            scale   : scale
        });
        up.pointerPressed = function()
        {
            this super._player.direction = #up;
        }
        this.add(up);

        var down = new ImageButton({
            image   : "app://down.png",
            x       : System.width - 2*width,
            y       : System.height - width,
            scale   : scale
        });
        down.pointerPressed = function()
        {
            this super._player.direction = #down;
        }
        this.add(down);

        var left = new ImageButton({
            image   : "app://left.png",
            x       : System.width - 3*width,
            y       : System.height - width - width / 2,
            scale   : scale
        });
        left.pointerPressed = function()
        {
            this super._player.direction = #left;
        }
        this.add(left);

        var right = new ImageButton({
            image   : "app://right.png",
            x       : System.width - width,
            y       : System.height - width - width / 2,
            scale   : scale
        });
        right.pointerPressed = function()
        {
            this super._player.direction = #right;
        }
        this.add(right);
    }

    // protected
    function createEnemies()
    {
    }
}