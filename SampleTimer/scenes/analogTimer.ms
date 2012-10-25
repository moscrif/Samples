include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class AnalogTimer : Scene
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

        this.add(new AnalogClock());
    }

    function draw(canvas)
    {
        canvas.clear(0xaaffffff);

        super.draw(canvas);
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

}
