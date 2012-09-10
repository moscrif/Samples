include "lib://box2d/physicsSprite.ms";

class Ball : PhysicsSprite
{
    function init()
    {
        super.init();
        //image ball-ingame.png
        this.image = res.img.ball;
        this.radius = 14.0;
        this.shape = null;
        this.shapeType = #circle;
        this.bodyType = #dynamic;
        this.density = 0.0;
        this.friction = 0.0;
        this.bounce = 1.0;
    }

    function afterInit()
    {
        super.afterInit();
        this._createBody();
    }
}