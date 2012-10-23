include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

include "app://ballon.ms"
include "app://loseDialog.ms"

class SinglePlayerScene : PhysicsScene
{
    var maxForce = 2000;
    var forceStep = 0.1;

    function init()
    {
        super.init();

        this.world = new b2World(0.0, -9.81, true, true);

        this._tap = false;
        this._force = 0;
        this._angle = 0;
        this._canFire = true;

        this._time = 1500;

        this._bodiesToDestroy = new Array();

        this.setTimer();
        this._createBariers();

        this._linePaint = new Paint();
        this._linePaint.color = 0xAA3DCC00;
        this._linePaint.strokeWidth = 4;
        this._ended = false;
    }

    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);

        if(this._ended) {
            this._goBack();
            return;
        }

        var distanceX = x - System.width / 2;
        var distanceY = y - 9*System.height / 10;
        // calculate angle
        this._angle = Math.atan2(distanceY, distanceX);
        this._tap = true;

        var distance = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
        var maxDistance = 3*System.height / 5;
        if (distance > maxDistance)
            distance = maxDistance;
        this._force = (1.0*distance / maxDistance)*maxForce;
    }

    function pointerDragged(x, y)
    {
        super.pointerDragged(x, y);

        if(this._ended)
            return;

        var distanceX = x - System.width / 2;
        var distanceY = y - 9*System.height / 10;
        // calculate angle
        this._angle = Math.atan2(distanceY, distanceX);

        var distance = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
        var maxDistance = 3*System.height / 5;
        if (distance > maxDistance)
            distance = maxDistance;
        this._force = (1.0*distance / maxDistance)*maxForce;
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);

        if(this._ended)
            return;

        this._tap = false;
        this._fire();
    }

    function afterInit()
    {
        super.afterInit();

        this._ballons = new Array();
    }

    function _fire()
    {
        if (!this._canFire)
            return;

        this._ball = this.addCircleBody(GFX.ball, #dynamic, 1.0, 1.0, 1.0, GFX.ball.width / 2);
        this._ball.setPosition(System.width / 2, 9*System.height / 10);
        this._ball.id = #ball;
        this._ball.bullet = true;

        var velox = this._force*Math.cos(this._angle)/this.scale;
        var veloy =-this._force*Math.sin(this._angle)/this.scale;

        this._ball.setLinearVelocity(velox, veloy);
        this._canFire = false;

        var t = new Timer(1, 1);
        t.onTick = function ()
        {
            this super._canFire = true;
        }
        t.start(500);
    }

    function setTimer(i = 1)
    {
        this._timer = new Timer(1, 1);
        this._timer.onTick = function()
        {
            this super._createBallon(i);
            if (this super._time > 200)
                this super._time -= 3;
            i += 0.1;
            this super.setTimer(i);
        }
        this._timer.start(this._time);
    }

    function _createBallon(i)
    {
        var ballon = PhysicsSprite.create(this, GFX.ballon, new b2CircleShape((GFX.ballon.width / 10) / this.scale), #kinematic, 1.0, 0.0, 0.0, Ballon);//ar ballon = new Ballon({
        ballon.id = #ballon;
        ballon.end = function(body)
        {
            this super.restart(body);
        }
        ballon.bullet = true;
        ballon.setLinearVelocity(0, 0.3*i/10);
        var x = rand(System.width/2 - 2*GFX.ballon.width) + GFX.ballon.width;
        if (rand(2) == 1)
            x += System.width / 2;

        ballon.setPosition(x, System.height);
    }

    function restart(body)
    {
        this._bodiesToDestroy.push(body);
        this.add(new LoseDialog());
        this._ended = true;
    }

    function draw(canvas)
    {
        canvas.clear(0xFF0094FF);

        canvas.save();
        canvas.translate(System.width / 2, 9*System.height / 10);
        canvas.rotate(this._angle*180.0/Math.PI);
        canvas.drawLine(0, 0, (1.0*this._force / maxForce * 1*System.height / 2).toInteger(), 0, this._linePaint)
        canvas.restore();

        super.draw(canvas);

        canvas.drawBitmap(GFX.grass, 0, 4*System.height / 5 + 1);
    }

    function process()
    {
        var timeStep = 1.0 / 40.0;
        // recalculate physics world. All objects are moved about timeStep
        this.step(timeStep, 4, 8);

        if (this._tap) {
            if (this._force > maxForce)
                this._force = 0;
            else
                this._force += forceStep;
        }

        if (this._bodiesToDestroy.length != 0)
            this._destroyBodies();

    }

    function _destroyBodies()
    {
        // Remove touched bricks
        for(var body in this._bodiesToDestroy) {
            if (body.timer)
                body.timer.dispose();
            this.destroyBody(body);
        }

        // zero the array
        this._bodiesToDestroy = new Array();
    }

    function beginContact(contact)
    {
        var current = contact;
        while (current) {
            // get both bodies in contact
            var bodyA = current.getBodyA();
            var bodyB = current.getBodyB();
            if (bodyA.id == #ball && bodyB.id == #ballon) {
                this._bodiesToDestroy.push(bodyB);
            } else if(bodyB.id == #ball && bodyA.id == #ballon) {
                this._bodiesToDestroy.push(bodyA);
            } else if(bodyB.id == #border) {
                this._bodiesToDestroy.push(bodyA);
            } else if(bodyA.id == #border) {
                this._bodiesToDestroy.push(bodyB);
            }
            // get next body
            current = current.getNext();
        }
    }


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

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }
}
