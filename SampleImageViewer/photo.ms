include "lib://game2d/sprite.ms"

class Photo : Sprite
{
    function init()
    {
        super.init();
        
        this._photo = null;
        // paint is used for alpha level reduce effect
        this.paint = new Paint();
    }

    // @region system events
    function draw(canvas)
    {
        super.draw(canvas);
        
        canvas.drawBitmap(this._preview, this.x - this._preview.width / 2, this.y - this._preview.height / 2, this.paint);
    }

    function process()
    {
        var gap = Math.abs(this.x - System.width / 2);
        // change alpha acording to the curent position
        this.paint.alpha = (255-(1.0*gap/(System.width))*255).toInteger();
    }
    // @endregion

    // @region functions
    function resizePhoto()
    {
        var hScale = 1.0*System.height / this._photo.height;
        var wScale = 1.0*System.width / this._photo.width;

        // only zoom out not in
        if (hScale < 1.0 || wScale < 1.0)
            // use smaller scale
            if (hScale < wScale)
                this._preview = this._photo.resize((this._photo.width*hScale).toInteger(), (this._photo.height*hScale).toInteger());
            else
                this._preview = this._photo.resize((this._photo.width*wScale).toInteger(), (this._photo.height*wScale).toInteger());
        else
            this._preview = this._photo;
    }
    // @endregion

    // @region propeties
    property photo(v)
    {
        get return this._photo;
        set {
            this._photo = v;
            this.resizePhoto();
        }
    }
    // @endregion
}