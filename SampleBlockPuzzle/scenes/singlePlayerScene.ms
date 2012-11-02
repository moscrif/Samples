include "lib://game2d/textButton.ms"
include "app://playGround.ms"

include "app://gameOverLayer.ms"

class SinglePlayerScene : Scene
{
    function init()
    {
        super.init();

        this.playGround = new PlayGround({
            columns     : 16,
            rows        : 26,
            image       : GFX.tiles,
            tileWidth   : GFX.tiles.width / 3,
            tileHeight  : GFX.tiles.height / 2,
            margin      : 0,
            scene       : this;
        });
        this.add(this.playGround);

        this.gameOver = new GameOverLayer();

        this._lastX = -1;
        this._dragged = false;
    }

    function pointerPressed(x, y)
    {
        if (this.playGround.gameOver) {
            this.playGround.restart();
            this.detach(this.gameOver);
        }

        this._lastX = x;
        this._lastY = y;
        this._dragged = false;
    }

    function pointerDragged(x, y)
    {
        if (this.playGround.gameOver)
            return;
    
        var gapX = (x - this._lastX) / this.playGround.tileWidth;
        var gapY = (y - this._lastY) / this.playGround.tileHeight;
    
        if (gapX != 0) {
            this.playGround.block.move(gapX / Math.abs(gapX));
            this._dragged = true;
            this._lastX = x;
        }
    
        if (gapY > 0) {
            this.playGround.fastMove();
            this._dragged = true;
            this._lastY = y;
        }
    }

    function pointerReleased(x, y)
    {
        if (this.playGround.gameOver)
            return;

        if (!this._dragged && this.playGround.block)
            this.playGround.block.changeState();
        this._dragged = false;
    }

    property scene(v)
    {
        get return this._scene;
        set this._scene = v;
    }
}