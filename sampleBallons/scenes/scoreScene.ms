// Date: 8. 11. 2012 21:13:02
// Author: palo on PALOSATALA

include "lib://game2d/scene.ms"

class ScoreScene : Scene
{
    function init()
    {
        super.init();

        // get access to the highscore table
        this._table = new Leaderboard().getTable();

        // paint used for text
        this._textPaint = new Paint();
        this._textPaint.color = 0xffdddddd;
        this._textPaint.textSize = System.width / 30;

        this.add(new Label({
            text        : "High score",
            x           : System.width / 2,
            y           : System.height / 10,
            color       : 0xffffffff,
            textSize    : System.width / 20
        }));

        this._back = new TextButton({text:"Back", x:System.width/2, y:9*System.height/10, frameWidth : 100, frameHeight : 100});
        this._back.onClick = function() {
            Game.instance.pop(new SlideToBottom());
        }
        this.add(this._back);
    }

    function draw(canvas)
    {
        // custom drawings
        for (var i = 0; i < this._table.length; i++) {
            canvas.drawText((i+1).toString() + ".", System.width / 20, System.height / 15 * i + System.height / 5, this._textPaint);
            canvas.drawText(this._table[i].score + " points", System.width / 5, System.height / 15 * i + System.height / 5, this._textPaint);
            canvas.drawText(this._table[i].date, System.width / 2, System.height / 15 * i + System.height / 5, this._textPaint);
        }
        // call (optional) default drawings
        super.draw(canvas);
    }
}