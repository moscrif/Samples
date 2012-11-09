include "lib://game2d/layer.ms"

class LoseDialog : Layer
{
    function init()
    {
        super.init();

        // add rext to the layer
        this.add(new Label({
            text    : "Score:",
            color   : 0xffffffff,
            x       : System.width / 2,
            y       : System.height / 4,
            z       : 2,
            textSize    : System.width / 20
        }));
        // add rext to the layer
        this._scoreLabel = new Label({
            text    : "",
            color   : 0xffffffff,
            x       : System.width / 2,
            y       : System.height / 2,
            z       : 2,
            textSize    : System.width / 20
        });
        this.add(this._scoreLabel);
    }

    property score(v)
    {
        get console<<"get only\n";
        set this._scoreLabel.text = v.toString();
    }

    function draw(canvas)
    {
        // draw background
        canvas.clear(0xff000000);

        super.draw(canvas);
    }
}