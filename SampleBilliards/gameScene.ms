class GameScene : PhysicsScene
{
    function init()
    {
        super.init();

        this.whiteBall = null;
        // create physics world
        this.world = new b2World(0.0, 0.0, true, true);
        // this.world.setContinuousPhysics(false);
        this.debugDraw = true;
        this._createBarriers();
        this._createHoles();
        this.debugDraw = true;
        this._createBalls();
        this.createWhiteBall();

        this._direction = null;
        this.angle = 0.0;
        this.ballsMoving = false;
        this._control = #nothing;
        this._cuePosition = 40;

        this._forceBar = new ForceBar({
            width   : System.width,
            height  : System.height,
        });
        this.add(this._forceBar);
        this._forceBar.force = 0.0;

        this._createRefreshBttn();  // create refresh button
        this._createCloseBttn();    // create close button
    }

    function beginContact(contact)
    {
        var current = contact;
        while (current) {
            var bodyA = current.getBodyA();
            var bodyB = current.getBodyB();
            if (bodyA.id == #hole)
                bodyB.hide();
            else if (bodyB.id == #hole)
                bodyA.hide();
            current = current.getNext();
        }
    }

    function pointerPressed(x, y, pointer)
    {
        super.pointerPressed(x, y);

        if(this.ballsMoving)
            return;

        if (x<System.width - res.number.barWidth) {
            // compute actual distance from start position
            var (ballX, ballY) = this.whiteBall.getPosition();
            var distanceX = x - ballX;
            var distanceY = y - ballY;
    
            this.angle=Math.atan2(distanceY, distanceX);
            this._direction = {
                x   : x,
                y   : y,
            }
            this._control = #angle;
        } else {
            var force = (y - (System.height / 2 - 140.0)) / 280;
            if (force < 0)
                force = 0.0;
            else if (force > 1.0)
                force = 1.0;
            force = 1-force;
            this._forceBar.force = force;

            this._control = #power;
        }
    }

    function pointerDragged(x, y, pointer)
    {
        super.pointerDragged(x, y);
        if(this.ballsMoving)
            return;
        if (this._control == #angle) {
            // compute actual distance from start position
            var (ballX, ballY) = this.whiteBall.getPosition();
            var distanceX = x - ballX;
            var distanceY = y - ballY;
    
            this.angle=Math.atan2(distanceY, distanceX);
            this._direction = {
                x   : x,
                y   : y,
            }
        } else if (this._control == #power) {
            var force = (y - (System.height / 2 - 140.0)) / 280;
            if (force < 0)
                force = 0.0;
            else if (force > 1.0)
                force = 1.0;
            force = 1-force;
            this._forceBar.force = force;
        }
    }

    function pointerReleased(x, y, pointer)
    {
        super.pointerReleased(x, y);
        if(this.ballsMoving)
            return;

        if (this._control == #angle) {

        } else if (this._control == #power) {
            var force = this._forceBar.force * res.number.maxForce;
            var velox = force*Math.cos(this.angle)*20/this.scale;
            var veloy=-force*Math.sin(this.angle)*20/this.scale;
            // set li near velocity to the ball
            this.whiteBall.setLinearVelocity(velox, veloy);
            this.ballsMoving = true;
            this._control == #nothing;
        }

    }

    function createWhiteBall()
    {
        if (this.whiteBall) {
            this.destroyBody(this._whiteBody);
        }
        var shape = new b2CircleShape(res.number.ballRadius / this.scale);
        this.whiteBall = PhysicsSprite.create(this, res.images.sonicRoll, shape, #dynamic, 1.0, 0.0, 1.0, Ball);
        this.whiteBall.setPosition(System.width / 4, System.height/2);
        this.whiteBall.color = 0xffffffff;
        this.whiteBall.setLinearDamping(res.number.tableDamping);
        this.whiteBall.bullet = true;
        this.whiteBall.id = #whiteBall;
    }

    function _createBalls()
    {
        this.balls = new Array();

        var gap = Math.sqrt((res.number.ballRadius*res.number.ballRadius)/2);

        var shape = new b2CircleShape(res.number.ballRadius / this.scale);
        var ball = 0;
        var number = 0;
        for (var i = 0; i < 5; i++)
            for (var q = 0; q < i+1; q++) {
                ball = PhysicsSprite.create(this, res.images.sonicRoll, shape, #dynamic, 1.0, 0.0, 1.0, Ball);
                ball.setPosition(res.number.ballX + 2*i*gap, res.number.ballY + i*gap - 2*q*gap);
                ball.bullet = true;
                ball.setLinearDamping(res.number.tableDamping);
                ball.color = res.ballColor[number];
                ball.ballType = res.ballType[number];
                ball.id = #ball;
                number++;
                this.balls.push(ball);
            }
        this.balls[4].color = 0xff000000;
        this.balls[4].ballType = #full;
    }

    function _createHoles()
    {
        // top
        var hole = this.addCircleBody(res.image.hole, #static, 0.0, 0.0, 0.0, 1);
        hole.setPosition(res.number.tableLeft + res.number.mantinel, res.number.tableTop + res.number.mantinel);
        hole.scale = 1.0*res.number.holeRadius / (res.image.hole.width / 2);
        hole.id = #hole;

        hole = this.addCircleBody(res.image.hole, #static, 0.0, 0.0, 0.0, 1);
        hole.setPosition(res.number.tableLeft + res.number.tableWidth / 2, res.number.tableTop + res.number.mantinel);
        hole.scale = 1.0*res.number.holeRadius / (res.image.hole.width / 2);
        hole.id = #hole;

        hole = this.addCircleBody(res.image.hole, #static, 0.0, 0.0, 0.0, 1);
        hole.setPosition(res.number.tableLeft + res.number.tableWidth - res.number.mantinel, res.number.tableTop + res.number.mantinel);
        hole.scale = 1.0*res.number.holeRadius / (res.image.hole.width / 2);
        hole.id = #hole;

        // bottom
        hole = this.addCircleBody(res.image.hole, #static, 0.0, 0.0, 0.0, 1);
        hole.setPosition(res.number.tableLeft + res.number.mantinel, res.number.tableTop + res.number.tableHeight - res.number.mantinel);
        hole.scale = 1.0*res.number.holeRadius / (res.image.hole.width / 2);
        hole.id = #hole;

        hole = this.addCircleBody(res.image.hole, #static, 0.0, 0.0, 0.0, 1);
        hole.setPosition(res.number.tableLeft + res.number.tableWidth / 2, res.number.tableTop + res.number.tableHeight - res.number.mantinel);
        hole.scale = 1.0*res.number.holeRadius / (res.image.hole.width / 2);
        hole.id = #hole;

        hole = this.addCircleBody(res.image.hole, #static, 0.0, 0.0, 0.0, 1);
        hole.setPosition(res.number.tableLeft + res.number.tableWidth - res.number.mantinel, res.number.tableTop + res.number.tableHeight - res.number.mantinel);
        hole.scale = 1.0*res.number.holeRadius / (res.image.hole.width / 2);
        hole.id = #hole;

    }

    function _createBarriers()
    {
        // top
        var shape = [
            {x: res.number.tableWidth / -4 + res.number.holeRadius, y : res.number.mantinel / 2 },
            {x: res.number.tableWidth / -4 + res.number.holeRadius + res.number.mantinel, y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 - res.number.holeRadius, y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4, y : res.number.mantinel / 2},
        ];

        this.addPolygonBody(null, #static, 1.0, 0.0, 1.0, shape).setPosition(res.number.tableLeft + res.number.tableWidth / 4, res.number.tableTop + res.number.mantinel / 2);
        shape = [
            {x: res.number.tableWidth / -4, y : res.number.mantinel / 2 },
            {x: res.number.tableWidth / -4 + res.number.holeRadius, y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 - res.number.mantinel - res.number.holeRadius, y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 - res.number.holeRadius, y : res.number.mantinel / 2},
        ];
        this.addPolygonBody(null, #static, 1.0, 0.0, 1.0, shape).setPosition(res.number.tableLeft + 3*res.number.tableWidth / 4, res.number.tableTop + res.number.mantinel / 2);

        // bottom
        shape = [
            {x: res.number.tableWidth / -4 + res.number.holeRadius + res.number.mantinel, y : res.number.mantinel / 2 },
            {x: res.number.tableWidth / -4 + res.number.holeRadius , y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 , y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 - res.number.holeRadius, y : res.number.mantinel / 2 },
        ];

        this.addPolygonBody(null, #static, 1.0, 0.0, 1.0, shape).setPosition(res.number.tableLeft + res.number.tableWidth / 4, res.number.tableTop - res.number.mantinel / 2 + res.number.tableHeight);
        shape = [
            {x: res.number.tableWidth / -4 + res.number.holeRadius, y : res.number.mantinel / 2 },
            {x: res.number.tableWidth / -4, y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 - res.number.holeRadius  , y : res.number.mantinel / -2 },
            {x: res.number.tableWidth / 4 - res.number.holeRadius - res.number.mantinel, y : res.number.mantinel / 2 },
        ];
        this.addPolygonBody(null, #static, 1.0, 0.0, 1.0, shape).setPosition(res.number.tableLeft + 3*res.number.tableWidth / 4, res.number.tableTop - res.number.mantinel / 2 + res.number.tableHeight);

        // left
        shape = [
            {x: res.number.mantinel / -2, y : res.number.tableHeight / 2 - res.number.holeRadius},
            {x: res.number.mantinel / -2, y : res.number.tableHeight / -2 + res.number.holeRadius},
            {x: res.number.mantinel / 2, y : res.number.tableHeight / -2 + res.number.mantinel + res.number.holeRadius},
            {x: res.number.mantinel / 2, y : res.number.tableHeight / 2 - res.number.mantinel - res.number.holeRadius},
        ];
        this.addPolygonBody(null, #static, 1.0, 0.0, 1.0, shape).setPosition(res.number.tableLeft + res.number.mantinel / 2, System.height / 2);

        // right
        shape = [
            {x: res.number.mantinel / -2, y : res.number.tableHeight / 2 - res.number.holeRadius - res.number.mantinel},
            {x: res.number.mantinel / -2, y : res.number.tableHeight / -2 + res.number.holeRadius + res.number.mantinel},
            {x: res.number.mantinel / 2, y : res.number.tableHeight / -2 + res.number.holeRadius},
            {x: res.number.mantinel / 2, y : res.number.tableHeight / 2 - res.number.holeRadius},
        ];
        this.addPolygonBody(null, #static, 1.0, 0.0, 1.0, shape).setPosition(res.number.tableLeft + res.number.tableWidth - res.number.mantinel / 2, System.height / 2);
    }

    function _checkBallsSpeed()
    {
        this.ballsMoving = false;
        var speed;
        var (x, y);
        if (this.whiteBall) {
            (x, y) = this.whiteBall.getLinearVelocity();
            speed = Math.sqrt(x*x + y*y);
            if (speed > res.number.minSpeed) {
                this.ballsMoving = true;
                return;
            }
        }

        for (var i in this.balls) {
            (x, y) = i.getLinearVelocity();
            speed = Math.sqrt(x*x + y*y);

            if (speed > res.number.minSpeed) {
                this.ballsMoving = true;
                return;
            }
        }
    }

    function draw(canvas)
    {
        canvas.clear(0xffffffff);

        canvas.drawBitmapNine(res.image.table, res.number.tableLeft, res.number.tableTop, res.number.tableLeft + res.number.tableWidth, res.number.tableTop + res.number.tableHeight);
        if (!this.ballsMoving) {
            canvas.save();
            canvas.clipRect(res.number.tableLeft + res.number.mantinel, res.number.tableTop + res.number.mantinel, res.number.tableLeft + res.number.tableWidth - res.number.mantinel, res.number.tableTop + res.number.tableHeight-res.number.mantinel, #intersect );
            var (x, y) = this.whiteBall.getPosition();
            x = x.toInteger();
            y = y.toInteger();
            canvas.translate(x, y);
            canvas.rotate(this.angle*180.0/Math.PI - 90);
    
            canvas.drawLine(0, 0, 0, res.number.lineLength, res.paint.line);
            canvas.restore();
    
            canvas.save();
            canvas.translate(x, y);
            canvas.rotate(this.angle*180.0/Math.PI);
    
            canvas.drawBitmap(res.image.cue, -1*res.image.cue.width - this._cuePosition, res.image.cue.height / -2);
            canvas.restore();
        }

        super.draw(canvas);
    }

    function process()
    {
        super.process();
        // create step in physics world
        this.step(1.0/40.0);
        if (this.whiteBall)
            this._checkBallsSpeed();
    }

    function _createRefreshBttn()
    {
        this._refreshBttn = new ImageButton({
            image   : res.image.refresh,
            x       : System.width / 20,
            y       : System.height / 10,
            z       : 3,
        });
        this._refreshBttn.onClick = function()
        {
            for (var i in this super.balls)
                this super.destroyBody(i);
            console<<"0\n";
            this super.balls = new Array();
            console<<"1\n";
          //  this super.createWhiteBall();
            console<<"2\n";
            this super._createBalls();
            console<<"3\n";
        }
        this.add(this._refreshBttn);
    }

    function _createCloseBttn()
    {
        this._closeBttn = new ImageButton({
            image   : res.image.close,
            x       : 19*System.width / 20,
            y       : System.height / 10,
            z       : 3,
            onClick : ::game.quit()
        });
        this.add(this._closeBttn);
    }
}