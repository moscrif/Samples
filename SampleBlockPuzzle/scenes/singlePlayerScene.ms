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
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

    function pointerPressed()
    {
        console<<"pressed\n";
        this.playGround.block.changePosition();
    }

}
