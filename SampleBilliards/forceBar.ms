class ForceBar : Layer
{
    function init()
    {
        super.init();

        this._paint = new Paint();
        this._force = 0.0;
    }

    property force(v)
    {
        set {
            this._paint.shader = this._createShader(v);
            this._force = v;
        }
        get return this._force;
    }

    function _createShader(y)
    {
        //y = -1*y;
        var pts = {
            start :
            { 
                x: System.width / 2,
                y : System.height / 2 - (y*280).toInteger(),
            },
            end :
            {
                x: System.width / 2,
                y : System.height / 2 + 280 - (y*280).toInteger(),
            }
        }
        var clrs = new Array(0x00000000, 0xff9F0000, 0x00000000);
        var pos = new Array(0.0, 0.5, 1.0);
        return Shader.linear(pts, clrs, pos, 0);
    };

    function draw(canvas)
    {
        // speed
        canvas.drawText("speed up", 9*System.width / 10, System.height/2 - 165, res.paint.textPaint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 + 140, 6, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 + 121, 7, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 + 100, 8, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 + 77, 9, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 + 52, 10, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 + 25, 11, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 - 4, 12, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 - 35, 13, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 - 68, 14, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 - 103, 15, this._paint);
        canvas.drawCircle(System.width - res.number.barWidth / 2, System.height / 2 - 140, 16, this._paint);

        canvas.drawText("speed down", 9*System.width / 10, System.height/2 + 175, res.paint.textPaint);
    }
}