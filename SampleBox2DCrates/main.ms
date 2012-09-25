include "lib://box2d/physicsScene.ms"

// create native application window
var app = new Moscrif.Window();
app._terminate = false;

app.onStart = function()
{
    // creates paint used t draw information about fps
    this._paint = new Paint();
    this._paint.color = 0xff000000;
    this._paint.textSize = 15;

    this._mouseJoint = null;

    // creates physics world
    var xGravity = 0.0;                 // zero gravity on x axis (horizontally)
    var yGravity = -9.8;                // real gravity on y axis (vertically)
    var sleep = false;                  // forbit sleeping (bodies fall asleep, when they are in rest) it improves performance
    var enableCollisions = true;        // enable colisions between two bodies
    // create physics scene
    this._world = PhysicsScene.create(xGravity, yGravity, sleep, enableCollisions);

    // load crates image into memory
    var imgBox = Bitmap.fromFile("app://box.png");

    // creates paint for drawing of ground
    var paint = new Paint();
    paint.color = 0xaabbccdd;

    // create ground
    var (width, height) = (System.width, 50);
    this._ground = this._world.addPolygonBody(null, #static, 0.0 /*density*/, 5.2/*friction*/, 0.0/*bounce*/, width, height);
    this._ground.setPosition(System.width/2, System.height - height/2);
    this._ground.onDraw = :sender, canvas :canvas.drawRect(-sender.width/2, -sender.height/2, sender.width/2, sender.height/2, paint);
    
    // create walls
    (width, height) = (1, System.height);
    var leftMantinel = this._world.addPolygonBody(null, #static, 0.0/*density*/, 0.0/*friction*/, 0.0/*bounce*/, width, height);
    leftMantinel.setPosition(leftMantinel.width/2, System.height/2);
    
    (width, height) = (1, System.height);
    var rightMantinel = this._world.addPolygonBody(null, #static, 0.0/*density*/, 0.0/*friction*/, 0.0/*bounce*/, width, height);
    rightMantinel.setPosition(System.width - (rightMantinel.width/2), System.height/2);
    
    (width, height) = (System.width, 1);
    var topMantinel = this._world.addPolygonBody(null, #static, 0.0/*density*/, 0.0/*friction*/, 0.0/*bounce*/, width, height);
    topMantinel.setPosition(System.width/2, (topMantinel.height/2));

    // create crates
    var (crateWidth, crateHeight) = (imgBox.width, imgBox.height);
    this._bodies = new Array();
    // set number of crates acording to screen width
    const cratesNum = System.width > 320 ? 12 : 4;
    for (var i = 0; i < cratesNum; i++) {
        var body = this._world.addPolygonBody(imgBox, #dynamic, 0.9 /*density*/, 0.0/*friction*/, 0.0/*bounce*/, crateWidth, crateHeight);
        // place body to random position
        body.setPosition((System.width / (5)) * (i%4 + 1) + rand(10), (System.height-(130+(i%5)*130) - rand(30)) - height/2, 0);
        // push the body to the array
        this._bodies.push(body);
    }

    // check if device supports acceleration sensor
    if (Sensor.isAvailable(#acceleration)) {
        // create sensor
        var sensor = new Sensor(#acceleration, 40);
        sensor.onDataReceived = function(sender, timestamp, params)
        {
            // set gravity acording to device position
            this super._world.setGravity(-params[0] * 10., -params[1] * 10.);
        };
        // start senzor data receiving
        sensor.start();
    }
}

app.onProcess = function()
{
    // return zero when quit requested
    if (this._terminate)
        return 0;
    // calculate physics
    this._world.step(1.0 / 40.0, 4, 8);
    this._world.clearForces();
    this.invalidate();
    return 1;
}

app.onPointerPressed = function(sender, x, y)
{
    // if user cliked to quit button quit application
    if (y > (System.height - 50)) {
        app._terminate = true;
        return;
    }

    this._mouseJoint = null;
    for(var body in this._bodies) {
        // calculate border of body
        var (bx, by) = body.getWorldCenter();
        var realBx1 = bx - body.width/2;
        var realBx2 = bx + body.width/2;
        var realBy1 = by - body.height/2;
        var realBy2 = by + body.height/2;
        // check if user cliked inside dthe body
        if ((realBx1 <= x && x <= realBx2) && (realBy1 <= y && y <=  realBy2)) {
            // create additional joint settings
            var mouseJointDef = {
                maxForce        : 2500,
                frequencyHz     : 10000,
                dampingRatio    : 0.0,
                targetX         : x / this._world.scale,
                targetY         : (System.height-y) / this._world.scale
            };
            // crate mouse joint
            this._mouseJoint = this._world.createMouseJoint(this._ground, body, mouseJointDef, true);
        }
    }
}

app.onPointerDragged = function(sender, x, y)
{
    // check if mouse joint exists
    if (this._mouseJoint != null) {
        // convert screen to box2d coordinates
        var b2y = (System.height-y) / this._world.scale;
        var b2x = x / this._world.scale;
        // set new target to mouse joint
        this._mouseJoint.setTarget(b2x, b2y);
    }
}

app.onPointerReleased = function(sender, x, y)
{
    //destroy mouse joint when user release the crate
    if(this._mouseJoint != null)
        this._world.destroyJoint(this._mouseJoint);
    this._mouseJoint = null;
}

app.onKeyPressed = function(sender, key)
{
    app._terminate = (key == #back || key == #end || key == #ok || key == #menu);
}

app.onDraw = function(sender, canvas)
{
    // clear window using solid color
    canvas.clear(0xff999999);
    // draw physics world
    this._world.draw(canvas);
    // this._world.doDebugDraw(canvas);
    // draw infos
    canvas.drawText(String.printf("FPS: %.2f", System.avgFPS), 30, 50, app._paint);
    canvas.drawText("drag box, turn device or tap here to quit", 30, System.height - 30, app._paint);
}

// initilaizes - allow FPS
app.init(true);
// runs main application object
app.run();

// eof
