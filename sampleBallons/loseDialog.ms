include "lib://game2d/layer.ms"

class LoseDialog : Layer
{
    function init()
    {
        super.init();

        this.add(new Label({
            text    : "You have lost the game!!!",
            color   : 0xffffffff,
            x       : System.width / 2,
            y       : System.height / 4,
            z       : 2,
            textSize    : System.width / 20
        }));

        this._back = new TextButton({text:"Back", x:System.width/2, y:3*System.height/4, frameWidth : 100, frameHeight : 100});
        this._back.onClick = function() {
            console<<"llik\n";
            this super._goBack();
        }
        this.add(this._back);
    }

    function draw(canvas)
    {
        canvas.clear(0xff000000);

        super.draw(canvas);
    }
}