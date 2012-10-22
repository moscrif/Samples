include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class SinglePlayerScene : PhysicsScene
{
    function init()
    {
        super.init();

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);
    }

    function draw(canvas)
    {
        canvas.clear(0xFF0094FF);

        canvas.drawBitmap(GFX.grass, 0, 4*System.height / 5 + 1);
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

}
