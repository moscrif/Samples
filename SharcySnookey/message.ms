class Message : Layer
{
    function init()
    {
        super.init();

        this.width = System.width;
        this.height = System.height;

        this._textPaint = new Paint();
        this._textPaint.color = 0xffffffff;
        this._textPaint.textSize = System.height / 20;

        this._bg = new Paint();
        this._bg.color = 0xaa000000;

        this._text = "";
        this._scene = null;
        this._textWidth = 0;
    }

    function pointerPressed(x, y)
    {
        game.push(new Level1());
        this._scene.detach(this);
    }

    function draw(canvas)
    {
        canvas.drawRect(0,0,System.width, System.height, this._bg);

        canvas.drawText(this._text, (System.width - this._textWidth) / 2, System.height / 2, this._textPaint);
    }

    property text(v)
    {
        get return this._text;
        set {
            this._text = v;
            var (w, h) = this._textPaint.measureText(this._text);
            this._textWidth = w;
        }
    }

    property scene(v)
    {
        get return this._scene;
        set {
            this._scene = v;
        }
    }
}