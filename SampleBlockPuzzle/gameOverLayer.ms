include "lib://game2d/layer.ms"
include "lib://game2d/label.ms"

class GameOverLayer : Layer
{
    function init()
    {
        super.init();

        this._paint = new Paint();
        this._paint.color = 0xffffffff;
        this._paint.textSize = System.height / 20;

        this._score = 0;

        this.add(new Label({
            text    : "Game over!",
            paint   : this._paint,
            y       : System.height / 3,
            x       : System.width / 2
        }));

        this._scoreL = new Label({
            text    : "score: " + this._score,
            paint   : this._paint,
            y       : System.height / 2,
            x       : System.width / 2
        });
        this.add(this._scoreL);
    }

    function draw(canvas)
    {
        canvas.clear(0xaa000000);

        super.draw(canvas);
    }

    property score(v)
    {
        get return this._score;
        set {
            this._score = v;
            this._scoreL.text = "score: " + this._score;
        }
    }
}