class GameScene : PhysicsScene
{
    function init()
    {
        super.init();

        this.whiteBall = null;
        // create physics world
        this.world = new b2World(0.0, 0.0, true, true);
        this._createBarriers();
        this._createHoles();
        this._createBalls();
        this.createWhiteBall();
        
        this.angle = 0.0;
        this.ballsMoving = false;
        this._control = #nothing;
        // gap between the ball and cue
        this._cuePosition = 25;
        // add layer with bar controling the hit force
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
            // get both bodies in contact
            var bodyA = current.getBodyA();
            var bodyB = current.getBodyB();
            var x, y;
            // hide ball if something hit the hole (the hole can hit only ball)
            if (bodyA.id == #hole) {
                (x, y) = bodyA.getPosition();
                bodyB.hide(x, y);
            }
            else if (bodyB.id == #hole) {
                (x, y) = bodyB.getPosition();
                bodyA.hide(x, y);
            }
            // get next body
            current = current.getNext();
        }
    }

    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);
        // if some ball is moving do nothing
        if(this.ballsMoving)
            return;
    
        if (x<System.width - res.number.barWidth) {
            // compute actual distance from the white ball
            var (ballX, ballY) = this.whiteBall.getPosition();
            var distanceX = x - ballX;
            var distanceY = y - ballY;
            // calculate angle
            this.angle=Math.atan2(distanceY, distanceX);
    
            this._control = #angle;
        }
    }

    function pointerDragged(x, y)
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
        }
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);
        if(this.ballsMoving)
            return;

        if (this._control == #angle) {
            this._control = #nothing;
        }
    }

    function createWhiteBall()
    {
        if (this.whiteBall != null) {
            this.destroyBody(this.whiteBall);
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
        hole.setPosition(res.number.tableLeft + res.number.tableWidth / 2, res.number.tableTop + res.number.mantinel - 2);
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
        hole.setPosition(res.number.tableLeft + res.number.tableWidth / 2, res.number.tableTop + res.number.tableHeight - res.number.mantinel + 2);
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
        canvas.clear(0xffaaaaaa);
    
        canvas.drawBitmapRect(res.image.table, 0, 0, res.image.table.width, res.image.table.height, res.number.tableLeft, res.number.tableTop, res.number.tableLeft + res.number.tableWidth, res.number.tableTop + res.number.tableHeight);
        var (x, y);
        if (!this.ballsMoving) {
            // save canvas without transalation
            canvas.save();
            // restirct the drawing area
            canvas.clipRect(res.number.tableLeft + res.number.mantinel, res.number.tableTop + res.number.mantinel, res.number.tableLeft + res.number.tableWidth - res.number.mantinel, res.number.tableTop + res.number.tableHeight-res.number.mantinel, #intersect );
            (x, y) = this.whiteBall.getPosition();
            x = x.toInteger();
            y = y.toInteger();
            canvas.translate(x, y);
            canvas.rotate(this.angle*180.0/Math.PI - 90);
    
            canvas.drawLine(0, 0, 0, res.number.lineLength, res.paint.line);
            // restore saved canvas
            canvas.restore();
        }
        // draw box2d world
        super.draw(canvas);
    
        if (!this.ballsMoving) {
            (x, y) = this.whiteBall.getPosition();
            x = x.toInteger();
            y = y.toInteger();
            // save canvas without transalation
            canvas.save();
            // move and rotate canvas
            canvas.translate(x, y);
            canvas.rotate(this.angle*180.0/Math.PI);
            // draw cue
            canvas.drawBitmap(res.image.cue, -1*res.image.cue.width - this._cuePosition, res.image.cue.height / -2);
            // restore saved canvas
            canvas.restore();
        }
    
        // draw FPS
        canvas.drawText(String.printf("FPS: %2.f", System.avgFPS), 50, 50, res.paint.textPaint);
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
            this super.balls = new Array();
            this super.createWhiteBall();
            this super._createBalls();

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