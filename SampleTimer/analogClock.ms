class AnalogClock : Layer
{
    function init()
    {
        super.init();

        this._clockX = System.width / 2;
        this._clockY = System.height / 2;
        this._clockWidth = System.width / 2;

        this._setDefaultPaints();

        this._secondAngle = 0;
        this._minuteAngle = 0;
        this._hourAngle = 0;
    }

    function draw(canvas)
    {
        super.draw(canvas);

        this.drawClockFace(canvas);

        canvas.save();
        canvas.translate(this._clockX, this._clockY);
        canvas.rotate(this._secondAngle);
        canvas.drawLine(0, 0, 0, this._clockWidth / -2 + this._clockWidth / 20, this._secondLine);
        canvas.restore();

        canvas.save();
        canvas.translate(this._clockX, this._clockY);
        canvas.rotate(this._minuteAngle);
        canvas.drawLine(0, 0, 0, this._clockWidth / -2 + this._clockWidth / 10, this._minuteLine);
        canvas.restore();

        canvas.save();
        canvas.translate(this._clockX, this._clockY);
        canvas.rotate(this._hourAngle);
        canvas.drawLine(0, 0, 0, this._clockWidth / -2 + this._clockWidth / 4, this._hourLine);
        canvas.restore();
    }

    function process()
    {
        // get current date (hour, minute, second)
        var t = new Date();
        // second angle
        this._secondAngle = t.second*1.0 / 60 * 360;
        this._minuteAngle = t.minute*1.0 / 60 * 360 /* whole part*/ + (t.second * 1.0 / 60)*6/*second part for smoth run*/;
        this._hourAngle = (t.hour%12)*1.0 / 12 * 360 /* whole part*/ + (t.minute * 1.0 / 60)*30/*minute part for smoth run*/;
    }

    function drawClockFace(canvas)
    {
        canvas.save();
        canvas.translate(this._clockX, this._clockY);
        for (var i = 1; i < 61; i++) {
            canvas.rotate(6);
            if (i%5 == 0)
                canvas.drawLine(this._clockWidth / 2, 0, this._clockWidth / 2 - this._clockWidth / 10, 0, this._longLine);
            else
                canvas.drawLine(this._clockWidth / 2, 0, this._clockWidth / 2 - this._clockWidth / 20, 0, this._shortLine);
        }
        canvas.restore();
    }

    function _setDefaultPaints()
    {
        this._longLine = new Paint();
        this._longLine.strokeWidth = 2;

        this._shortLine = new Paint();
        this._shortLine.strokeWidth = 1;

        this._secondLine = new Paint();
        this._secondLine.strokeWidth = 3;
        this._secondLine.strokeCap = #round;

        this._minuteLine = new Paint();
        this._minuteLine.strokeWidth = 5;
        this._minuteLine.strokeCap = #round;

        this._hourLine = new Paint();
        this._hourLine.strokeWidth = 6;
        this._hourLine.strokeCap = #round;
    }
}