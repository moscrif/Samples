include "lib://box2d/physicsScene.ms";
include "lib://game2d/gameButton.ms";

class GameScene : PhysicsScene
{
    function afterInit()
    {
        // call parent's afterInit function
        super.afterInit();

        // graphics scale
        this.grScale = 1.0*System.width/1024;
        // initial initialization
        this.angle = 0.0;
        this.distance = 0.0;
        this.pressed = false;
        this.boxes = new Array();
        // init ball position
        this.ballStart = {
            x : 7*System.width / 10,
            y : 4*System.height / 10,
        }
        this.maxDistance = 2 * System.width / 10;
        this._mouseJoint = null;
        // create mantinels
        this._createMantinels();
        this._createCrates(); // create crates
        this._createBird(); // create ball
        this._createRefreshBttn(); // create refresh button
        this._createCloseBttn(); // create close button*/
    }

    // @region pointer events
    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);

        if (this._mouseJoint == null)
            return;
        var radius = res.image.bird.width / 2;
        // get position of ball
        var (bx, by) = this.bird.getWorldCenter();
        // compute boundaries of ball
        var realBx1 = bx - radius;
        var realBx2 = bx + radius;
        var realBy1 = by - radius;
        var realBy2 = by + radius;
        // check intersect with pointer
        if ((realBx1 <= x && x <= realBx2) && (realBy1 <= y && y <=  realBy2)) {
            this.pressed = true;
        }

    }

    function pointerDragged(x, y)
    {
        super.pointerDragged(x, y);

        if (!this.pressed)
            return;

        // compute actual distance from start position
        var distanceX = x - this.ballStart.x;
        var distanceY = y - this.ballStart.y;
        // compute angle
        this.angle=Math.atan2(distanceY,distanceX);
        // distance
        this.distance = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
        if (this.distance > this.maxDistance)
            this.distance = this.maxDistance;

        x=this.ballStart.x + this.distance*Math.cos(this.angle);
        y=this.ballStart.y + this.distance*Math.sin(this.angle);
        // recompute distance
        var b2y = (System.height - y) / this.scale;
        var b2x = x / this.scale;
        // set target new target of mouse joint
        this._mouseJoint.setTarget(b2x, b2y);
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);

        if (!this.pressed)
            return;

        this.pressed = false;
        this.destroyJoint(this._mouseJoint);
        this._mouseJoint = null;

        // compute velocity vector
        var velox=-this.distance*Math.cos(this.angle)*20/this.scale;
        var veloy=this.distance*Math.sin(this.angle)*20/this.scale;
        // set linear velocity to the ball
        this.bird.setLinearVelocity(velox, veloy);
    }

    /**
    Event is called when scene is redraw
    @event
    @param canvas Canvas
    */
    function draw(canvas)
    {
        canvas.drawBitmap(res.image.background, (System.width - res.image.background.width) / 2, (System.height - res.image.background.height) / 2);
        canvas.drawBitmap(res.image.tree, 7*System.width / 10 - res.image.tree.width / 2, System.height - res.image.tree.height);

        if (this.pressed && this.distance != 0) {
            canvas.save();
            // compute actual distance from start position
            var distanceX = this.bird.x - this.ballStart.x;
            var distanceY = this.bird.y - this.ballStart.y;
            // compute angle
            var angle=Math.atan2(distanceY,distanceX);
            canvas.translate(this.bird.x, this.bird.y);
            canvas.rotate(angle * 180.0/Math.PI);
            canvas.scale(this.grScale, this.grScale);
            //
            var (l, t, r, b) = res.vector.backArrow.getBounds();
            canvas.scale(-1.5*this.distance / Math.abs(r-l), 1);
            canvas.drawPath(res.vector.backArrow, res.arrowPaint);
            canvas.translate(Math.abs(l - r), 0);

            canvas.scale(-1/(1.5*this.distance / Math.abs(r-l)), 1);
            canvas.drawPath(res.vector.arrow, res.arrowPaint);
            
            canvas.restore();
        }

        super.draw(canvas);
        //canvas.drawBitmap(res.image.grass, (System.width - res.image.grass.width) / 2, System.height - res.image.grass.height);
    }

    function process()
    {
        super.process();
        this.step();
        // if ball lose his speed set flags and creates new one
        if (this._mouseJoint)
            return;
        var (vx, vy);
        if (this.bird) {
            (vx, vy) = this.bird.getLinearVelocity();
            var speed = Math.sqrt(vx*vx + vy*vy);
            if (!this.pressed && speed<0.2) {
                var t = new Timer(1, 1);
                t.onTick = function()
                {
                    var self = this super;
                    var (vx, vy);
                    if (self.bird && !self._mouseJoint) {
                        (vx, vy) = self.bird.getLinearVelocity();
                        var speed = Math.sqrt(vx*vx + vy*vy);
                        if (speed<0.2) {
                            self.destroyBody(self.bird);
                            self.bird = null;
                            self._createBird();
                        }
                    }
                }
                t.start(1300);
            }
        }
    }

    // @region Private functions
    function _createMantinels()
    {
        // ground
        var (width, height) = (System.width, 1);
        this._ground = this.addPolygonBody(res.image.grass, #static, 0, 5, 0.5, width, height); // density, friction, bounce
        this._ground.z = 2;
        this._ground.setPosition(System.width/2, System.height - res.image.grass.height/2*this.grScale);
        // left mantinel
        (width, height) = (1, System.height);
        var leftMantinel = this.addPolygonBody(null, #static, 0, 5, 0.5, width, height);
        leftMantinel.setPosition(0, System.height/2);
        // right mantinel
        (width, height) = (1, System.height);
        var rightMantinel = this.addPolygonBody(null, #static, 0, 5, 0.5, width, height);
        rightMantinel.setPosition(System.width, System.height/2);
        // top mantinel
        (width, height) = (System.width, 1);
        var topMantinel = this.addPolygonBody(null, #static, 0, 5, 0.5, width, height);
        topMantinel.setPosition(System.width/2, 0);
    }

    function _createCrates()
    {
        var offset = rand((res.image.box.width*this.grScale / 5).toInteger()) - res.image.box.width*this.grScale / 10;
        // create crates
        var box = 0;
        for (var i = 0; i < rand(3) + 5; i++) {
            box = this.addPolygonBody(res.image.box, #dynamic, 0.5, 0.5, 0, res.image.box.width*this.grScale, res.image.box.height*this.grScale);
            box.scale = this.grScale;
            box.setPosition(System.width/6 + offset, System.height - res.image.grass.height / 2 * this.grScale - i*res.image.box.height*this.grScale - res.image.box.height*this.grScale/2);
            this.boxes.push(box);
            offset = rand((res.image.box.width*this.grScale / 5).toInteger()) - res.image.box.width*this.grScale / 10;
        }
        for (var i = 0; i < rand(3) + 4; i++) {
            box = this.addPolygonBody(res.image.box, #dynamic, 0.5, 0.5, 0, res.image.box.width*this.grScale, res.image.box.height*this.grScale);
            box.scale = this.grScale;
            box.setPosition(System.width/3 + offset, System.height - res.image.grass.height / 2 * this.grScale - i*res.image.box.height*this.grScale - res.image.box.height*this.grScale/2);
            this.boxes.push(box);
            offset = rand((res.image.box.width*this.grScale / 5).toInteger()) - res.image.box.width*this.grScale / 10;
        }
    }

    function _createBird()
    {
        if (this._mouseJoint != null)
            this.destroyJoint(this._mouseJoint);

        // create body
        this.bird = this.addCircleBody(res.image.bird, #dynamic, 0.5, 0.5, 0.1, res.image.bird.width/2*this.grScale);
        this.bird.scale = this.grScale;
        this.bird.setLinearDamping(0.5);
        this.bird.bullet = true;
        // set position
        this.bird.setPosition(this.ballStart.x, this.ballStart.y);
        var mouseJointDef = {
            maxForce        : 10000,
            frequencyHz     : 100000,
            dampingRatio    : 0.0,
            targetX         : this.ballStart.x / this.scale,
            targetY         : (System.height-this.ballStart.y) / this.scale
        };
        this._mouseJoint = this.createMouseJoint(this._ground, this.bird, mouseJointDef, false);
         this.angle = 0.0;
        this.distance = 0.0;
    }

    function _createRefreshBttn()
    {
        this._refreshBttn = new ImageButton({
            image   : res.image.refresh,
            x       : System.width / 20,
            y       : 9*System.height / 10,
            z       : 3,
            scale   : this.grScale
        });
        this._refreshBttn.onClick = function()
        {
            var self = this super;
            if (self._mouseJoint) {
                self.destroyJoint(self._mouseJoint);
                self._mouseJoint = 0;
            }
            self.destroyBody(self.bird);
            for (var i in self.boxes)
                self.destroyBody(i);
            self.boxes = new Array();
            self._createCrates();
            self._createBird();
        }
        this.add(this._refreshBttn);
    }

    function _createCloseBttn()
    {
        this._closeBttn = new ImageButton({
            image   : res.image.close,
            x       : 19*System.width / 20,
            y       : 9*System.height / 10,
            z       : 3,
            onClick : ::game.quit()
        });
        this._closeBttn.scale = this.grScale;
        this.add(this._closeBttn);
    }
}