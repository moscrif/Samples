include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

include "app://ballon.ms"
include "app://loseDialog.ms"

class SinglePlayerScene : PhysicsScene
{
    // constants
    const maxForce = 2000;
    const forceStep = 0.1;
    const maxDistance = 3*System.height / 5;

    function init()
    {
        super.init();

        this.start = System.tick;
    
        this.world = new b2World(0.0, -9.81, true, true);

        // if user tap the screen - true
        this._tap = false;
        // actual force
        this._force = 0;
        // actual angle
        this._angle = 0;
        // can fire? it takes some time to reload :) (about 500ms)
        this._canFire = true;
        // the time between first two ballons
        this._time = 1500;
        this._score = 0;
        this._leaderborad = new Leaderboard();
        // bodies to be destroyd in the next process method
        this._bodiesToDestroy = new Array();
        // has the game ended?
        this._ended = false;
        // start ballon creation
        this._setTimer();
        // create bariers around a playground
        this._createBariers();

        // create paints
        this._linePaint = new Paint();
        this._linePaint.color = 0xAA3DCC00;
        this._linePaint.strokeWidth = 4;

        this._textPaint = new Paint();
        this._textPaint.textSize = System.height / 20;
    }

    // @region user events
    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);

        if(this._ended) {
            this._leaderborad.insert(this._score);
            this._goBack();
            return;
        }

        // calculate distance on both axis
        var distanceX = x - System.width / 2;
        var distanceY = y - 9*System.height / 10;
        // calculate angle
        this._angle = Math.atan2(distanceY, distanceX);
        // total distance
        var distance = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
        // max distance (max distance is distance which equal the max force)
        if (distance > maxDistance)
            distance = maxDistance;
        // calculate force
        this._force = (1.0*distance / maxDistance)*maxForce;
    }

    function pointerDragged(x, y)
    {
        super.pointerDragged(x, y);

        // calculate distance on both axis
        var distanceX = x - System.width / 2;
        var distanceY = y - 9*System.height / 10;
        // calculate angle
        this._angle = Math.atan2(distanceY, distanceX);
        // total distance c*c = a*a + b*b
        var distance = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
        if (distance > maxDistance)
            distance = maxDistance;
        this._force = (1.0*distance / maxDistance)*maxForce;
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);

        // release touch
        this._tap = false;
        // fire a ball
        this._fire();
    }
    // @endregion

    // @region system events
    function draw(canvas)
    {
        // fill the screen by the blue color
        canvas.clear(0xFF0094FF);

        canvas.save();
        // move and rotate canvas
        canvas.translate(System.width / 2, 9*System.height / 10);
        canvas.rotate(this._angle*180.0/Math.PI);
        // draw line which specfies the angle and force
        canvas.drawLine(0, 0, (1.0*this._force / maxForce * 1*System.height / 2).toInteger(), 0, this._linePaint)
        canvas.restore();

        // draw box2d
        super.draw(canvas);

        // convert and show time
        var seconds = (System.tick - this.start) / 1000;
        var minutes = seconds / 60;
        seconds = seconds%60;
        if (minutes < 10)
            minutes = "0" + minutes;
        if (seconds < 10)
            seconds = "0" + seconds;
        canvas.drawText(minutes + ":" + seconds, 10, System.height / 20, this._textPaint);
        // draw grass
        canvas.drawBitmap(GFX.grass, 0, 4*System.height / 5 + 1);
    }

    function process()
    {
        // make timestep in physics simulation
        var timeStep = 1.0 / 40.0;
        // recalculate physics world. All objects are moved about timeStep
        this.step(timeStep, 4, 8);

        if (this._tap) {
            if (this._force > maxForce)
                this._force = 0;
            else
                this._force += forceStep;
        }
        // destoy bodies if it is needed
        if (this._bodiesToDestroy.length != 0)
            this._destroyBodies();

    }
    // @endregion

    // @region box2d events
    function beginContact(contact)
    {
        var current = contact;
        while (current) {
            // get both bodies in contact
            var bodyA = current.getBodyA();
            var bodyB = current.getBodyB();
            // check if a ballon was hit
            if (bodyA.id == #ball && bodyB.id == #ballon) {
                // destoy ballon
                this._bodiesToDestroy.push(bodyB);
                this._score += 1;
            // check if a ballon was hit
            } else if(bodyB.id == #ball && bodyA.id == #ballon) {
                // destoy ballon
                this._bodiesToDestroy.push(bodyA);
                this._score += 1;
            // check if something hit the border (only ball can)
            } else if(bodyB.id == #border) {
                this._bodiesToDestroy.push(bodyA);
            } else if(bodyA.id == #border) {
                this._bodiesToDestroy.push(bodyB);
            }
            // get next body
            current = current.getNext();
        }
    }
    // @endregion

    // @region public methods
    // restart level
    function restart(body)
    {
        // destroy all bodies
        this._bodiesToDestroy.push(body);
        this.add(new LoseDialog({score : this._score}));
        this._ended = true;
    }
    // @endregion

    // @region private methods
    function _fire()
    {
        // if can not fire do nothing
        if (!this._canFire)
            return;

        // add new ball
        this._ball = this.addCircleBody(GFX.ball, #dynamic, 1.0, 0.0, 0.0, GFX.ball.width / 2);
        this._ball.setPosition(System.width / 2, 9*System.height / 10);
        this._ball.id = #ball;
        this._ball.bullet = true;

        // start veloity of the ball acording to angle and force
        var velox = this._force*Math.cos(this._angle)/this.scale;
        var veloy =-this._force*Math.sin(this._angle)/this.scale;

        //apply velocity
        this._ball.setLinearVelocity(velox, veloy);

        // diable next fire
        this._canFire = false;
        // allow fire after 500ms
        var t = new Timer(1, 1);
        t.onTick = function ()
        {
            this super._canFire = true;
        }
        t.start(500);
    }

    function _setTimer(i = 1)
    {
        this._timer = new Timer(1, 1);
        this._timer.onTick = function()
        {
            // create ballon
            this super._createBallon(i);
            // decrease the time between two ballons
            if (this super._time > 200)
                this super._time -= 3;
            i += 0.1;
            this super._setTimer(i);

        }
        this._timer.start(this._time);
    }

    function _createBallon(i)
    {
        // create ballon
        var ballon = PhysicsSprite.create(this, GFX.ballon, new b2CircleShape((GFX.ballon.width / 10) / this.scale), #kinematic, 0.5, 0.0, 0.0, Ballon);//ar ballon = new Ballon({
        ballon.id = #ballon;
        // set callback, which is called when the ballon exceed the top of the screen
        ballon.end = function(body)
        {
            this super.restart(body);
        }
        // allow ccd on this body
        ballon.bullet = true;
        ballon.setLinearVelocity(0, 0.3*i/10);
        // random position
        var x = rand(System.width/2 - 2*GFX.ballon.width / 5) + GFX.ballon.width / 5;
        if (rand(2) == 1)
            x += System.width / 2;

        ballon.setPosition(x, System.height);
    }

    function _destroyBodies()
    {
        // remove all bodies in the array
        for(var body in this._bodiesToDestroy) {
            if (body.timer)
                body.timer.dispose();
            this.destroyBody(body);
        }

        // zero the array
        this._bodiesToDestroy = new Array();
    }

    // create border
    function _createBariers()
    {
        var top = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, 2*System.width,1);
        top.setPosition(System.width / 2, System.height/-2);
        top.id = #border;
        var down = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, 2*System.width, 1);
        down.setPosition(System.width / 2, System.height + System.height / 2);
        down.id = #border;
        var left = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, 1, 2*System.height);
        left.setPosition(System.width / -2, System.height/2);
        left.id = #border;
        var right = this.addPolygonBody(null, #static, 0.0, 0.0, 0.0, 1, 2*System.height);
        right.setPosition(System.width + System.width / 2, System.height / 2);
        right.id = #border;
    }

    // move to the menu
    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }
    // @endregion
}
