class Menu : Layer
{
    function init()
    {
        super.init();

        var close = Bitmap.fromFile("app://ico-close.png")
        this._closeBtn = new ImageButton({image : close, x : 3*System.width / 4 - close.width, y : close.height, onClick : function(){game.quit();}})
        this.add(this._closeBtn);

        var refresh = Bitmap.fromFile("app://ico-refresh.png")
        this._refreshBtn = new ImageButton({image : refresh, x : System.width / 4 + refresh.width, y : refresh.height, onClick : function(){this super._onRefresh();}})
        this.add(this._refreshBtn);

        this._textPaint = new Paint();
        this._textPaint.color = 0xff000000;
        this._textPaint.textSize = System.width / 35;
        var (w, h) = this._textPaint.measureText("graphics source: openclipart.org & hasgraphics.com");
        this._textPaint.style = #stroke;
        this._textWidth = w;

        this.translateX = 0;
        this.translateY = 0;
        this._onRefresh = null;
    }

    property onRefresh(v)
    {
        get return this._onRefresh;
        set {
            if (!(typeof v == #function || v == null))
                throw new InvalidArgument("[Menu.onRefresh] Expects type of function");
            this._onRefresh = v;
        }
    }

    function draw(canvas)
    {
        canvas.save()
        canvas.translate(-1*this.translateX, -1*this.translateY);

        super.draw(canvas);

        canvas.drawText("graphics source: openclipart.org & hasgraphics.com", (System.width - this._textWidth)/2, System.height / 14, this._textPaint);

        canvas.restore();
    }
}