include "lib://box2d/physicsSprite.ms";

class Disk : PhysicsSprite
{
    function init()
    {
        super.init();

        //image disks.png
        this.image = res.img.disks;
        this.frameWidth = 180;
        this.frameHeight = 51;
        // this.shape = null;
        this.shapeType = #polygon;
        this.bodyType = #static;
        this.density = 0.0;
        this.friction = 0.0;
        this.bounce = 0.1;
        this.enableSound = true;

        // start electric level after random time
        this._timer = new Timer(10000, false); // interval make no sense here
        this._timer.start(res.values.electricShockMin + rand(res.values.electricShockGap));
        this._timer.onTick = function(sender) {this super._eletricShock(1)};
    }

    function afterInit()
    {
        super.afterInit();
        this._createBody();
    }

    // @region properties
    property timer(v)
    {
        get return this._timer;
        set this._timer = v;
    }

    property enableSound(v)
    {
        get return this._enableSound
        set this._enableSound = v;
    }
    // @endregion

    // @region private function
    // create electric animation
    function _eletricShock(frame = 0)
    {
        // change current frame
        this.frame = frame;
        frame++;
    
        // if animation is on the last frame move to the first
        if (frame == 3)
            frame = 0;
    
        this._timer = new Timer(100, false); // interval make no sense here
        if (frame != 1)
            this._timer.start(100);
        else
            this._timer.start(res.values.electricShockMin + rand(res.values.electricShockGap));
        this._timer.onTick = function(sender) {this super._eletricShock(frame)};
    }
    // @endregion
}