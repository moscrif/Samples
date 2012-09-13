class Resources
{
    function this()
    {
        this._image = {
            background  : Bitmap.fromFile("app://graphics/scene.png"),
            grass       : Bitmap.fromFile("app://graphics/grass.png"),
            tree        : Bitmap.fromFile("app://graphics/tree.png"),
            bird        : Bitmap.fromFile("app://graphics/bird.png"),
            box         : Bitmap.fromFile("app://graphics/box.png"),
            close       : Bitmap.fromFile("app://graphics/ico-close.png"),
            refresh     : Bitmap.fromFile("app://graphics/ico-refresh.png"),
        }

        this._vector = {
            arrow  : Path.fromSVG("M 0 -25 L 0 25 L -30 0 z");
            backArrow  : Path.fromSVG("M 20 -7 L 20 7 L 0 0 z");
        }

        this.arrowPaint = new Paint();
        this.arrowPaint.color = 0xffeb1d22;
        // resize tree
        var scale = 1.0*System.width/1024;
        this._image.tree = this._image.tree.resize((this._image.tree.width * scale).toInteger(), (this._image.tree.height * scale).toInteger());
    }

    property image(v)
    {
        get return this._image;
    }

    property vector(v)
    {
        get return this._vector;
    }
}