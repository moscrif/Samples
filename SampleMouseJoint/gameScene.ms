class GameScene : PhysicsScene
{
// @region public functions
    function init()
    {
        super.init();
        // add new world to current scene with small gravity on y axis
        this.world = new b2World(0.0, -1.2, false, true);

        // add new circle body into curent scene
        this._circle = this.addCircleBody(Bitmap.fromFile("app://circle.png"), #dynamic, 1.0, 1.0, 1.0, 50);
        this._circle.setLinearDamping(2.5);
        // place circle into the middle of the screen
        this._circle.setPosition(System.width / 2, System.height / 2);

        // create ground body for mouse joint
        this._ground = this.addPolygonBody(null, #static, 0.0 /*density*/, 0.0/*friction*/, 0.0/*bounce*/, 0, 0);
        // crate variable for mouse joint
        this._mouseJoint = null;

        // create paint to draw joint line
        this._jointPaint = new Paint();
        this._jointPaint.color = 0xff0019A8;
        this._jointPaint.strokeWidth = 5;
        this._jointPaint.strokeCap = #round;

        // create paint to draw text
        this._textPaint = new Paint();
        this._textPaint.color = 0xffffffff;
        this._textPaint.textSize = System.height / 15;
        this._textWidth = new Array();
        var (w, h) = this._textPaint.measureText("Tap and drag");
        this._textWidth[0] = w;
        (w, h) = this._textPaint.measureText("to move the circle!");
        this._textWidth[1] = w;
    }

    // @region system events
    function draw(canvas)
    {
        // fill background with black color
        canvas.clear(0xff000000);
        // draw joint if it is created
        if (this._mouseJoint) {
            // get target box2d coordinates
            var (b2x, b2y) = this._mouseJoint.getTarget();
            // translate to screen (pixels) coordinates
            var (tx, ty) = this._b2screen(b2x, b2y);
            // get circle center coordinate
            var (cx, cy) = this._circle.getPosition();
            // draw line
            canvas.drawLine(tx.toInteger(), ty.toInteger(), cx.toInteger(), cy.toInteger(), this._jointPaint);
        }

        canvas.drawText("Tap and drag", (System.width - this._textWidth[0]) / 2, 7*System.height / 10, this._textPaint);
        canvas.drawText("to move the circle!", (System.width - this._textWidth[1]) / 2, 8*System.height / 10, this._textPaint);
        // call parents draw function (also draws box2d world)
        super.draw(canvas);
    }

    // reaction to onproces event (repeates about every 25 miliseconds)
    function process()
    {
       // create step in physics world
       this.step();
    }
    // @endregion

    // @region user events
    // reaction to pointer pressed event
    function pointerPressed(x, y)
    {
        // get position of circle
        var (cx, cy) = this._circle.getPosition();
        //set mouse joint
        var mouseJointDef = {
            maxForce        : 250 * this._circle.getMass(),                                      // max force, which attracts the body to the target point
            frequencyHz     : 100,
            dampingRatio    : 15.0,                                     // damping ratio - prevent oscillation of the body around the target point
            targetX         : cx / this.scale,                   // X position of anchor point on the body (circle)
            targetY         : (System.height - cy) / this.scale    // Y position of anchor point on the body (circle)

        };
        // crate mouse joint
        this._mouseJoint = this.createMouseJoint(this._ground, this._circle, mouseJointDef, true);
        if (this._mouseJoint != null) {
            // calculate target points (current pointer position)
            var b2y = (System.height-y) / this.scale;
            var b2x = x / this.scale;
            // set target
            this._mouseJoint.setTarget(b2x, b2y);
        }
    }

    // reaction to pointer draged event
    function pointerDragged(x, y)
    {
        // if mouse joint exists
        if (this._mouseJoint != null) {
            // calculate target point
            var b2y = (System.height-y) / this.scale;
            var b2x = x / this.scale;
            // set target
            this._mouseJoint.setTarget(b2x, b2y);
        }
    }

    // reaction to pointer released event
    function pointerReleased(x, y)
    {
        // if mouse joint exists destroy it
        if (this._mouseJoint != null) {
            this.destroyJoint(this._mouseJoint);
            this._mouseJoint = null;
        }
    }
    // @endregion
// @endregion

// @region private functions
    // convert b2coordinates to screen (pixel) coordinates
    function _b2screen(b2x, b2y)
    {
        var y = -1*b2y*this.scale + System.height;
        var x = b2x * this.scale;

        return (x, y);
    }
// @endregion
}