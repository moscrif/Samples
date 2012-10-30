class Star : Sprite
{
    function init()
    {
        super.init();

        this.image          = GFX.star;
        this.frameWidth     = 50;
        this.frameHeight    = 50;
        this.frame          = rand(19);
        this._speed = 2;

        this._timer = new Timer(50, true);
        this._timer.onTick = function()
        {
            var self = this super;
            self.frame += 1;

            if (self.frame > 19)
                self.frame = 0;

            self.x -= self.speed;
        }
        this._timer.start();
    }

    property speed(v)
    {
        get return this._speed;
        set this._speed = v;
    }
}