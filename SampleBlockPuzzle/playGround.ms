include "lib://game2d/tiledLayer.ms"
include "app://block.ms"

class PlayGround : TiledLayer
{
    function afterInit()
    {
        super.afterInit();

        // set cells to initial tile
        for (var i = 0; i < (this.rows * this.columns); i++) {
            this.setCellDirect(i, 0);
        }
        // place a grid
        this.x = System.width / 2;
        this.y = System.height / 2;

        // create a new block
        this._block = null;
        this._generateBlock();
        // start timer
        this.move();

        this._dragged = false;
        this._lastX = -1;

        // paint used for score text
        this._paint = new Paint();
        this._paint.color = 0xffffffff;
        this._paint.textSize = System.height / 20;

        // score
        this.score = 0;
        this.gameOver = false;
        // parent's scene
        this._scene = 0;
    }

    function draw(canvas)
    {
        super.draw(canvas);
        // draw score
        canvas.drawText("score: " + this.score, this.x - (this.columns * this.tileWidth) / 2 , System.height / 15, this._paint);
    }

    property block(v)
    {
        get return this._block;
        set ;// get only property
    }

    // start timer
    function move()
    {
        this._timer = new Timer(200, true)
        this._timer.onTick = function()
        {
            if (this super.gameOver)
                return;
    
            if (!this super._block.step()) {
                // if the bricck stay on the top of the screen
                if (this super._block.top < 2) {
                    // end the game
                    this super.gameOver = true;
                    this super.scene.add(this super.scene.gameOver);
                    this super.scene.gameOver.score = this super.score;
                }
                // check if no row is complete
                this super.checkRow();
                // generate new brick
                this super._generateBlock();
            }
        }
        this._timer.start(200);
    }

    function checkRow()
    {
        for (var i = this.rows-1; i > 0; i--) {
            for (var q = 0; q < this.columns; q++) {
                // a gab between blocks
                if (this.getCell(q, i) == 0)
                    break;
                if (q == this.columns - 1) {
                    this.removeLine(i);
                    i=i+1;
                }
            }
        }
    }

    function removeLine(r)
    {
        for (var i = r; i > 0; i--)
            for (var q = 0; q < this.columns; q++)
                this.setCell(q, i, this.getCell(q, i-1));
        this.score += 1;
    }

    function fastMove()
    {
        if (!this._block.step()) {
            if (this._block.top < 2) {
                this.gameOver = true;
            }
            this.checkRow();
            this._generateBlock();
        }
    }

    function restart()
    {
        this._block = null;
        for (var i = 0; i < this.rows; i++)
            for (var q = 0; q < this.columns; q++)
                this.setCell(q, i, 0);

        this._generateBlock();

        this.gameOver = false;
    }

    function _generateBlock()
    {
        this._block = new Block();
        this._block.playground = this;
    }
}

