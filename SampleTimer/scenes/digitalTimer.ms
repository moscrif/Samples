include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class DigitalTimer : Scene
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

        this._timer = new DigitalCutdown();
        this._timer.start(10);
        this._timer.finish = function()
        {
            logI("time: 00:00");
        }
        this.add(this._timer);
        this._running = false;
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

    function pointerPressed(x, y)
    {
        if (this._running) {
            this._running = false;
            this._timer.pause();
        } else {
            this._running = true;
            this._timer.continueCutDown();
        }

        super.pointerPressed(x, y)
    }

    function draw(canvas)
    {
        canvas.clear(0xaaffffff);

        super.draw(canvas);
    }
}
