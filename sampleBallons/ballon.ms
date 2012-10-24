class Ballon : PhysicsSprite
{
    function init()
    {
        super.init();

        // set image with frames
        this.image = GFX.ballon;
        // set frame dimension
        this.frameWidth = GFX.ballon.width / 5;
        this.frameHeight = GFX.ballon.height;

        // start timer
        this.timer = new Timer(100, true);
        this.timer.onTick = function()
        {
            // move to next frame
            if (this super.frame == 4/*number of frmes*/)
                this super.frame = 0;
            else
                this super.frame+=1;

            // check if the ballon does not passed the top of the screen
            var (x, y) = this super.getPosition();
            if (y < 0)
                this super._endHandler(this super);
            // speedup
            this super.setLinearVelocity(0, this super.getLinearVelocity() + 0.07);
        }
        this.timer.start(100);
    }

    // end level event
    property end(v)
    {
        get return this._endHandler;
        set this._endHandler = v;
    }
}