class SensorScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text: "Presnost merania je zavysla od presnosti a kalibracia vasho senzora", top : 10, marginY : 10, marginX: 5, fg : {color : 0xff000000}}));

        this._sensor = sensor;
        
        this._line = new Paint();
        this._line.color = 0xff003c68;
        this._line.strokeWidth = System.width / 150;
        this._line.strokeCap = #round;

        this._textPaint = new Paint();
        this._textPaint.textSize = System.width / 16;

        this._bg = new Paint();
        this._bg.color = 0xff0094ff;

        this._circle = new Paint();
        this._circle.color = 0xff003c68;
        this._circle.style = #stroke;
        this._circle.strokeWidth = System.width / 100;

        this._ball = new Paint();
        this._ball.color = 0xffcce9ff;
    }

    function draw(canvas)
    {
        // fill a bacground by gray color
        canvas.clear(0xffbbbbbb);
    
        // draw blue filled circle
        canvas.drawCircle(System.width / 2, System.height / 2, System.width / 3, this._bg);
        // draw four stroke circles
        for (var i = 0; i < 4; i++)
            canvas.drawCircle(System.width / 2, System.height / 2, i*System.width / 9 + 1, this._circle);
    
        // draw vertical line
        canvas.drawLine(System.width / 9, System.height / 2, 8*System.width / 9, System.height / 2, this._line);
        // draw horizontal line
        canvas.drawLine(System.width / 2, System.height / 2 - 7*System.width / 18, System.width / 2, System.height / 2 + 7*System.width / 18, this._line);
    
        if (this._sensor.angleX !== false && this._sensor.angleY !== false) {
            // draw circle ("bubble") acording to device position
            canvas.drawCircle(System.width / 2 + ((this._sensor.angleX/90.0)*(System.width / 3 - System.width / 18)).toInteger(), System.height / 2 - ((this._sensor.angleY/90.0)*(System.width / 3 - System.width / 18)).toInteger(), System.width / 18, this._ball);
    
            // show text with angle
            var (w, h) = this._textPaint.measureText("angle on x axis: " + this._sensor.angleX.toString());
            canvas.drawText("angle on x axis: " + this._sensor.angleX.toString(), System.width / 8, System.height / 10, this._textPaint);
            canvas.drawText("angle on y axis: "  + this._sensor.angleY.toString(), System.width / 8, System.height / 5, this._textPaint);
        }
    }
}