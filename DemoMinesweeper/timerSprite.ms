class TimerSprite : Sprite
{
    function init()
    {
        super.init();

        this.seconds = 0;
        this._timer = new Timer(1000, true);
        this._timer.onTick = function()
        {
            this super.seconds += 1;
            var minutes = this super.seconds / 60;
            if (minutes<10)
                minutes = "0" + minutes;

            var seconds = this super.seconds % 60;
            if (seconds<10)
                seconds = "0" + seconds;
            this super.timeString = minutes + ":" + seconds;
        }

        this.timeString = "00:00";
        var (w, h) = res.paints.counterText.measureText(this.timeString);
        this.textWidth = w;
        this.textHeight = h;

        this.start();
    }

    function start()
    {
        this._timer.start(1000);
    }

    function stop()
    {
        this._timer.stop();
    }

    function reset()
    {
        this.seconds = 0;
        this.timeString = "00:00";
    }

    function draw(canvas)
    {
        super.draw(canvas);

        canvas.save();
        canvas.translate(this.x, this.y);
        // draw text
        canvas.drawText(this.timeString, this.width / 2 - this.textWidth / 2, this.height / 2 + this.textHeight / 2, res.paints.counterText);
        canvas.restore()
    }
}