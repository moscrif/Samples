class DigitalCutdown : Layer
{
    var gap = 10;

    function init()
    {
        super.init();

        this.time = 0;     // seconds
        this._timer = 0;

        this._digits = new Array(GFX.zero, GFX.one, GFX.two, GFX.three, GFX.four, GFX.five, GFX.six, GFX.seven, GFX.eight, GFX.nine);

        this._timerX = System.width / 2;
        this._timerY = System.height / 2;
        this._finish = null;
    }

    property finish(v)
    {
        get return this._finish;
        set this._finish = v;
    }

    function start(time)
    {
        if (this._timer !== 0)
            this._timer.dispose();

        this.time = time;

        this._timer = new Timer(1000, true);
        this._timer.onTick = function()
        {
            this super.time -= 1;
            if (this super.time < 1) {
                this super._timer.dispose();
                this super._timer = 0;
                if (typeof this super._finish == #function)
                    this super._finish();
            }

        }
        this._timer.start(1000);
    }

    function pause()
    {
        if (this._timer !== 0)
            this._timer.stop();
    }

    function continueCutDown()
    {
        if (this._timer !== 0)
            this._timer.start();
    }

    function draw(canvas)
    {
        super.draw(canvas);

        var minute = this.time / 60;
        canvas.drawBitmap(this._digits[minute / 10], this._timerX - gap - 2*GFX.one.width - GFX.one.width / 2, this._timerY - GFX.one.height / 2);
        canvas.drawBitmap(this._digits[minute % 10], this._timerX - GFX.one.width - GFX.one.width / 2, this._timerY - GFX.one.height / 2);
        canvas.drawBitmap(GFX.dot, this._timerX - GFX.one.width / 2, this._timerY - GFX.one.height / 2);

        var seconds = this.time % 60;
        canvas.drawBitmap(this._digits[seconds / 10], this._timerX + GFX.one.width / 2, this._timerY - GFX.one.height / 2);
        canvas.drawBitmap(this._digits[seconds % 10], this._timerX + gap + GFX.one.width + GFX.one.width / 2, this._timerY - GFX.one.height / 2);
    }
}