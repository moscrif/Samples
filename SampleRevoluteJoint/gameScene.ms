class GameScene : PhysicsScene
{
// @region public functions
    function init()
    {
        super.init();

        // add new world to current scene with small gravity on y axis
        this.world = new b2World(0.0, 9.0, false, true);

        // load images
        this._pictureRectangle = Bitmap.fromFile("app://rect.png");
        this._pictureCircle = Bitmap.fromFile("app://circle.png");

        // create three rotors
        this._rotors = new Array();
        this._rotors.push(this._createRotor(System.width / 6, System.height / 2));
        this._rotors.push(this._createRotor(System.width / 2, System.height / 2));
        this._rotors.push(this._createRotor(5 * System.width / 6, System.height / 2));

        // lastStep = last run of onProcess - used for timing
        this._lastStep = 0;
        // create paint object for lines instead of joints
        this._jointPaint = new Paint();
        this._jointPaint.color = 0xff180cff;
        this._jointPaint.strokeWidth = 3;
        // create paint for text
        this._textPaint = new Paint();
        this._textPaint.color = 0xffffffff;
        this._textPaint.textSize = System.height / 15;
        // get text dimensions
        var (w, h) = this._textPaint.measureText("Tap to add new objects.");
        this._textWidth = w;

        // create mantinels
        this._createMantinels();
        // start accelerometer
        this._startSensor();
    }

    // @region user events
    // reaction to pointer pressed event
    function pointerPressed(x, y)
    {
        // renerate random shape (1 is rectangle body, else is circular body)
        var shape = rand(2);
        if (shape == 1) {
            // get dimensions of the body
            var (width, height) = (this._pictureRectangle.width, this._pictureRectangle.height);
            // create the body
            var body = this.addPolygonBody(this._pictureRectangle, #dynamic, 1.0 /*density*/, 1.0/*friction*/, 0.5/*bounce*/, width, height);
            // place the body
            body.setPosition(x, y);
        } else {
            // get dimensions of the body
            var radius = this._pictureCircle.width;
            // create the body
            var body = this.addPolygonBody(this._pictureCircle, #dynamic, 1.0 /*density*/, 1.0/*friction*/, 0.5/*bounce*/, radius, radius);
            // place the body
            body.setPosition(x, y);
        }
    }

    // @region system events
    function draw(canvas)
    {
        var x1, y1, x2, y2;
        // fill background with black color
        canvas.clear(0xff000000);
    
        // draw joints
        for (var i = 0; i < 3; i++) {
            // get position of both bodies
            (x1, y1) = this._rotors[i].bodyA.getPosition();
            (x2, y2) = this._rotors[i].bodyB.getPosition();
            // draw line
            canvas.drawLine(x1.toInteger(), y1.toInteger(), x2.toInteger(), y2.toInteger(), this._jointPaint);
        }
        // draw informative text
        canvas.drawText("Tap to add new objects.", (System.width - this._textWidth) / 2, 8*System.height / 10, this._textPaint);
        // draw other elements
        super.draw(canvas);
    }

    function process()
    {
        // default time step
        var timeStep = 1.0/40.0;
        // if this is not first run of this function
        if (this._lastStep != 0) {
            // calculate accurate time step
            timeStep = (System.tick*1.0 - this._lastStep) / 1000;
        }
        // create step in physics world
        this.step(timeStep);
        // update lastStep
        this._lastStep = System.tick;
    }
    // @endregion
// @endregion

// @region private functions
    function _createRotor(x, y)
    {
        var obj = {};
        // get dimensions of the body
        var (width, height) = (this._pictureRectangle.width, this._pictureRectangle.height);
    
        // static body, which do not moves
        obj.bodyA = this.addPolygonBody(this._pictureRectangle, #static, 0.0, 1.0, 1.0, width, height);
        // place the body
        obj.bodyA.setPosition(x, y);
    
        // create second rotating body
        obj.bodyB = this.addCircleBody(this._pictureCircle, #dynamic, 100.0, 0.0, 0.0, this._pictureCircle.width / 2);
        // place the body
        obj.bodyB.setPosition(x, y - System.width / 7 + this._pictureCircle.width / 4);
        // joint's options
        var jointSet = {
            enableMotor : true,             // enable motor
            motorSpeed  : (- 2 * Math.PI / 3) * (800.0 / System.width), // final speed is linearly depends on radius (screen resolution)
            maxMotorTorque : 2100000000,    // maximum torque
    
        }
        // create joint
        var joint = this.createRevoluteJoint(obj.bodyA, obj.bodyB, x, y, jointSet, true);
    
        // return object contains information about the joint
        return obj;
    }

    function _createMantinels()
    {
        // ground
        var (width, height) = (System.width, 1);
        var ground = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, width, height);
        ground.setPosition(System.width/2, System.height);

        // top mantinel
        (width, height) = (System.width, 1);
        var top = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, width, height);
        top.setPosition(System.width/2, 0);

        // left mantinel
        (width, height) = (1, System.height);
        var left = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, width, height);
        left.setPosition(0, System.height / 2);

        // right mantinel
        (width, height) = (1, System.height);
        var right = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, width, height);
        right.setPosition(System.width, System.height / 2);
    }

    function _startSensor()
    {
        // check if accelometer sensor is available
        if (!Sensor.isAvailable(#acceleration)) {
            System.messageBox("No accelometer detected!");
        } else {
            // create sensor
            var sensor = new Sensor(#acceleration, 40);
            // setup handler for receiving data
            sensor.onDataReceived = function(sender, timestamp, params) {
                var (x, y, z) = (params[0], params[1], params[2]);
                if (x > 0)
                    this super.setGravity(0, -1.8);
                else if (x < 0)
                    this super.setGravity(0, 1.8);
            };
            // start receiving data
            sensor.start();
        }
    }
// @endregion
}