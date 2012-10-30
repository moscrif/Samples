include "lib://game2d/textButton.ms"
include "app://playGround.ms"

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
        });
        this.add(this.playGround);

        this._lastX = -1;
        this._dragged = false;
    }

    function pointerPressed(x, y)
    {console<<"pressed\n";
        this._lastX = x;
        console<<"last x"<<this._lastX<<"\n";
        this._dragged = false;
    }

    function pointerDragged(x, y)
    {
        var gap = (x - this._lastX) / this.playGround.tileWidth;

        if (gap != 0) {
            this.playGround.block.move(gap);
            this._dragged = true;
            this._lastX = x;
        }
    }

    function pointerReleased(x, y)
    {
        if (!this._dragged && this.playGround.block)
            this.playGround.block.changePosition();
        this._dragged = false;
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

    

}
