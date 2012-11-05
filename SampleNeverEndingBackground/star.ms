class Star : Sprite
{
    function init()
    {
        super.init();

        // image with frames
        this.image          = GFX.star;
        this.frameWidth     = 50;
        this.frameHeight    = 50;
        // first frame (start from random position)
        this.frame          = rand(19);
        this._speed         = 0;
        this._scene         = null;

        // start animation timer
        this._timer = new Timer(50, true);
        this._timer.onTick = function()
        {
            var self = this super;
            // move to next frame
            self.frame += 1;
            if (self.frame > 19)
                self.frame = 0;

            // move star on x axis
            self.x -= self.speed;
            // remoe star if it is out of the screen
            if (self.x < -1*self.frameWidth) {
                // stop timer
                this.dispose();
                // remove star from the layer
                self.scene.detach(self);
            }
        }
        this._timer.start();
    }

    property speed(v)
    {
        get return this._speed;
        set this._speed = v / 20 /* steps per seconds */;
    }

    property scene(v)
    {
        get return this._scene;
        set this._scene = v;
    }
}