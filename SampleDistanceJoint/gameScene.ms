class GameScene : PhysicsScene
{
// @region public functions
    function init()
    {
        super.init();
        // add new world to current scene with small gravity on y axis
        this.world = new b2World(0.0, -9.8, false, true);

        // create two bodies with the distance joint
        this._createBodies();
        this._createBariers();
        // create paint objects used for drawing
        this._createPaints();
        // create variable for mouse joint - moves the bodies
        this._mouseJoint = null;
    }

    // @region system events
    function draw(canvas)
    {
        // fill background with black color
        canvas.clear(0xff000000);
        // draw joint if it is created
        var (rect1x, rect1y) = this._rect1.getPosition();
        var (rect2x, rect2y) = this._rect2.getPosition();
        // draw lines
        canvas.drawLine(rect1x.toInteger(), rect1y.toInteger(), rect2x.toInteger(), rect2y.toInteger(), this._jointPaint);

        canvas.drawText("Tap the body", (System.width - this._textWidth[0]) / 2, 7*System.height / 10, this._textPaint);
        canvas.drawText("and move it!", (System.width - this._textWidth[1]) / 2, 8*System.height / 10, this._textPaint);
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
        var mouseJointDef;
        // check if user clicked on the body
        if (this._rect1.intersectsPoint(x, y)) {
            // create joint to move the first rectangle
            mouseJointDef = {
                maxForce        : 500 * this._rect1.getMass(),                                      // max force, which attracts the body to the target point
                frequencyHz     : 100,
                dampingRatio    : 0.0,                                     // damping ratio - prevent oscillation of the body around the target point
                targetX         : x / this.scale,                   // X position of anchor point on the body (circle)
                targetY         : (System.height - y) / this.scale    // Y position of anchor point on the body (circle)
            };
            this._mouseJoint = this.createMouseJoint(this._ground, this._rect1, mouseJointDef, true);
        } else if (this._rect2.intersectsPoint(x, y)) {
            // create joint to move the first rectangle
            mouseJointDef = {
                maxForce        : 500 * this._rect2.getMass(),                                      // max force, which attracts the body to the target point
                frequencyHz     : 100,
                dampingRatio    : 0.0,                                     // damping ratio - prevent oscillation of the body around the target point
                targetX         : x / this.scale,                   // X position of anchor point on the body (circle)
                targetY         : (System.height - y) / this.scale    // Y position of anchor point on the body (circle)
            };
            this._mouseJoint = this.createMouseJoint(this._ground, this._rect2, mouseJointDef, true);
        } else {
            // do nothing
            return;
        }
    }

    // reaction to pointer draged event
    function pointerDragged(x, y)
    {
        // if mouse joint exists
        if (this._mouseJoint != null) {
            // calculate target point (convert from screen cordinates to box2d)
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
    // create two bodies and connect it with the distance joint
    function _createBodies()
    {
        // the body side
        var bodySide = 80;
        // first rectangle
        this._rect1 = this.addPolygonBody(Bitmap.fromFile("app://rectangle.png"), #dynamic, 1.0, 0.1, 0.7, bodySide, bodySide);
        // set body damping
        this._rect1.setLinearDamping(0.5);
        this._rect1.setAngularDamping(0.5);
        // place the body
        this._rect1.setPosition(System.width / 2, System.height / 2);
        // secod rectangle
        this._rect2 = this.addPolygonBody(Bitmap.fromFile("app://rectangle.png"), #dynamic, 1.0, 0.1, 0.7, bodySide, bodySide);
        // set body damping
        this._rect2.setLinearDamping(0.5);
        this._rect2.setAngularDamping(0.5);
        // place the body
        this._rect2.setPosition(System.width / 2, 3*System.height / 4);
        // create the distance joint
        var jointDef = {
            frequencyHz     : 100,
            dampingRatio    : 0.0,
           // distanceLength  : use default distance (distance which was between the bodies when they were created
        }
        this._distanceJoint = this.createDistanceJoint(this._rect1, this._rect2, System.width / 2,System.height / 2,System.width / 2,3*System.height / 4, jointDef, false)
    }

    function _createBariers()
    {
        // the ground is also used for mouse joint
        this._ground = this.addPolygonBody(null, #static, 0.0 /*density*/, 0.0/*friction*/, 0.0/*bounce*/, System.width, 1);
        this._ground.setPosition(System.width / 2, System.height);
        // top bariers
        var top = this.addPolygonBody(null, #static, 0.0 /*density*/, 0.0/*friction*/, 0.0/*bounce*/, System.width, 1);
        top.setPosition(System.width / 2, 0);
        // left bariers
        var left = this.addPolygonBody(null, #static, 0.0 /*density*/, 0.0/*friction*/, 0.0/*bounce*/, 1, System.height);
        left.setPosition(0, System.height / 2);
        // right bariers
        var right = this.addPolygonBody(null, #static, 0.0 /*density*/, 0.0/*friction*/, 0.0/*bounce*/, 1, System.height);
        right.setPosition(System.width, System.height / 2);
    }

    // create paints objects used for drawing
    function _createPaints()
    {
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
        // calculate the text dimensions
        var (w, h) = this._textPaint.measureText("Tap the body");
        this._textWidth[0] = w;
        (w, h) = this._textPaint.measureText("and move it!");
        this._textWidth[1] = w;
    }
// @endregion
}