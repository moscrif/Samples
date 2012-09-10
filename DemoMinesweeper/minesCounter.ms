class MinesCounter : Sprite
{
    function init()
    {
        super.init();

        // mines count
        this._count = 10;
        this._text = "10";
        this.height = res.integers.cellWidth;

        // calculate text dimensions
        var (w, h) = res.paints.counterText.measureText(this._text);
        this._textWidth = w;
        this._textHeight = h;
    }

    function draw(canvas)
    {
        super.draw(canvas);

        canvas.save();
        canvas.translate(this.x, this.y);

        canvas.drawText(this._text, this._textWidth, this._textHeight / 2, res.paints.counterText);
        canvas.drawPath(res.vectors.mine, res.paints.counterText);

        canvas.restore();
    }

    property count(v)
    {
        get return this._count;
        set {
            this._count = v;
            this._text = this._count.toString();
        }
    }
}