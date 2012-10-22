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
        this.x = System.width / 2;
        this.y = System.height / 2;

        this._block = null;

        this._generateBlock();


    }

    function _generateBlock()
    {
        this._block = new Block();
        this._block.playground = this;
        this._block.step();
        this.move();
    }

    function move()
    {
        this._timer = new Timer(500, true)
        this._timer.onTick = function()
        {
            this super._block.step();
        }
        this._timer.start(500);
    }

    property block(v)
    {
        get return this._block;
        set console<<"try to set get only property!!\n";
    }
}

