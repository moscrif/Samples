include "lib://game2d/layer.ms"
include "app://star.ms"

class Background : Layer
{
    function init()
    {
        super.init();
        // min and max gap between two starts
        this._minGap = 25;
        this._maxGap = 100;
        this._speed = 80; /* px / second */

        this._lastX = 0;
        // generate stars which appears on the screen when the game starts
        while (this._lastX < System.width) {
            this._lastX += rand(this._maxGap) + this._minGap;
            this.add(new Star({x : this._lastX, y : rand(System.height) + 10, speed : this._speed, scene : this}));
        }
        // add stars latery (during the application run)
        this._addStar();
    }

    function _addStar()
    {
        // distance of the next star
        var distance = this._minGap + rand(this._maxGap - this._minGap);
        this._lastX += distance;
        // add star when it is needed
        var t = new Timer(1, 1);
        t.onTick = function()
        {
            this super.add(new Star({x : this super._lastX, y : rand(System.height) + 10, speed : this super._speed, scene : this}));
            this super._addStar();
        }
        // time = distance / speed (distance is distance bfrom the last star)
        t.start((distance / (this._speed * 1.0 )/ 1000 /* seconds -> miliseconds */).toInteger())
    }

    function draw(canvas)
    {
        // fill background by the black color
        canvas.clear(0xffaaaaaa);

        super.draw(canvas);
    }
}