class Ballon : PhysicsSprite
{
    function init()
    {
        super.init();

        this.image = GFX.ballon;

        this.frameWidth = GFX.ballon.width / 5;
        this.frameHeight = GFX.ballon.height;
    
        this.timer = new Timer(100, true);
        this.timer.onTick = function()
        {
            if (this super.frame == 4/*number of frmes*/)
                this super.frame = 0;
            else
                this super.frame+=1;

            var (x, y) = this super.getPosition();

            if (y < 0)
                this super._endHandler(this super);
            // speedup
            this super.setLinearVelocity(0, this super.getLinearVelocity() + 0.07);
        }
        this.timer.start(100);
    }

    property end(v)
    {
        get return this._endHandler;
        set this._endHandler = v;
    }
}