include "lib://game2d/layer.ms"
include "app://star.ms"

class Background : Layer
{
    function init()
    {
        super.init();
        this._minGap = 25;
        this._maxGap = 100;
        this._speed = 2;

        this._lastX = 0;
        while (this._lastX < System.width) {
            this._lastX += rand(this._maxGap) + this._minGap;
            this.add(new Star({x : this._lastX, y : rand(System.height) + 10, speed : this._speed}));
        }
    }

    function draw(canvas)
    {
        // fill background by the black color
       canvas.clear(0xffaaaaaa);

        super.draw(canvas);
    }

    function _nextStar()
    {
        var t = new Timer(1, false);
        t.onTick = function()
        {
            this._lastX += 25;
            this super.add(new Star({x : this._lastX/*star radius*/, y : rand(System.height) + 10, speed : this super._speed}));
            this super._nextStar();
        }
        t.start(10);
    }
}