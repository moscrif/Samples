class GameScene : PhysicsScene
{
    // @region constructor
    function init()
    {
        super.init();

        this.brickCount = 0;
        this.paused = true;
        this._visible = true;
        // game options
        this._gameStarted = false;
        // load background image
        this._bg = res.img.gameBg;
        this._bg = this._bg.resize(System.width, System.height);
        // enable sounds
        this._enableSounds = true;
        this._level = 0;
        // bodies can not be destroyed or inactived on call backs functions - they are destroyed in process functtion
        this._bodiesToDestory = [];
        this._bodiesToInactive = [];
        // create button
        this._btnMenu = new ImageButton({image:res.img.menuButton, y: System.height / 20, x:System.width - res.img.menuButton.width});
        // increase the clicable area
        this._btnMenu.intersectsPoint = function (x, y)
        {
            if (x > this._x - res.img.menuButton.width && x < this._x + res.img.menuButton.width &&
                y < this._y + res.img.menuButton.height && y > this._y - res.img.menuButton.height)
                return true;
            else
                return false;
        }
        // onClick event - return to the menu
        this._btnMenu.onClick = function()
        {
           this super.visible = false;
           game.pop(new SlideToTop());
        }
        this.add(this._btnMenu);
        // apply animation
        this._pulseAnimation(this._btnMenu);
        // game over sprites shows message when the game ends. The sprite is created at the begining but it is set to invisible
        this._gameOver = new Sprite({image:res.img.gameOver, x: System.width/2, y:System.height/2})
        this._gameOver.visible = false;
        this.add(this._gameOver);

        // level sprites shows number of levels  The sprite is created here but it is set to invisible
        this._levelSprite = new Level({image:res.img.levels, x: System.width/2, y:System.height/2, frameWidth : res.img.levels.width, frameHeight : res.img.levels.height / 4, sequence : [0, 1, 2, 3]})
        this._levelSprite.visible = false;
        this.add(this._levelSprite);
    }

    // after physics world initialization
    function afterInit()
    {
        super.afterInit();

        // load sounds
        this._loadGameSounds();
        // create walls which prevent the ball to leave the playground
        this._createMantinels();
        this._createBall();
        this._createPaddle();
    }
    // @endregion


    // @region properties
    property paddle(v)
    {
        return this._paddle;
    }

    property ball(v)
    {
        return this._ball;
    }

    property level(v)
    {
        get return this._level;
        set {
            this._level = v;
        }
    }

    property visible(v)
    {
        get return this._visible;
        set {
            this._visible = v;
            // pause the game if it is invisible
            if (v == false)
                this.paused = true;
        }
    }
    // @endregion

    // @region public functions
    function draw(canvas)
    {
        // draw background
        canvas.drawBitmap(this._bg, 0, 0);
        // call parents draw function
        //  this._paddle.draw(canvas);
        this._world.doDraw(canvas);
        super.draw(canvas);
    }

    function process()
    {
        var timeStep = 1.0 / 40.0;
        // recalculate physics world. All objects are moved about timeStep
        if (!this.paused)
            this.step(timeStep, 4, 8);
    
        // remove bricks from the world
        if (this._bodiesToDestory.length != 0)
            this._removeBricks();
    
        // inactive bricks in the world
        if (this._bodiesToInactive.length != 0)
            this._inactiveBricks();
    
        // if user finished the level move to the next level
        if (this.brickCount == 0 && this.paused == false){
            this._nextLevel();
            this.paused = true;
        }
    }

    function pointerPressed(x, y)
    {
        super.pointerPressed(x,y);

        if (this.paused)
            return;

        // Initial impluse to ball
        if (this._gameStarted == false && this.brickCount > 0) {
            // the ball speed
            const speed = System.height/70;
            // the angle of the start impulse
            const alpha = 45;
            var (bx, by) = this._paddle.getWorldCenter();
            // calculate speed
            var vx = speed * Math.cos(alpha);
            var vy = speed * Math.sin(alpha);
            var (px, py) = this._ball.getWorldCenter();
            // apply impulse
            this._ball.applyLinearImpulse(vx, vy, bx, by);
            // start the game
            this._gameStarted = true;
        }
    }

    // move the body when user moves finger on the screen
    function pointerDragged(x, y)
    {
        super.pointerDragged(x,y);
    
        // if gam is paused do nothing
        if (this.paused)
            return;
    
        // pove the paddly only horizontally
        var (px, py) = this._paddle.getPosition();
        this._paddle.setPosition(x, py);
    }

    // restart the game
    function restart()
    {
        // destroy ball if exists
        if (this._ball != null){
            this.destroyBody(this._ball);
        }

        // pause the game
        this.paused = true;
        this._gameStarted = false;
        // create new ball
        this._createBall();
        // move paddle the initial position
        this._paddle.setPosition(this._paddleX, this._paddleY);

        // create brick after short pause
        var delay = new Timer(1, 1);
        delay.onTick = function(sender) {
            this super._createBricks();
            this super.paused = false;
        }
        // start timer to 600ms
        delay.start(600);
    }

    // start the game
    function start()
    {
        this._nextLevel();
    }

    //
    /*function detach()
    {
        this._timer.dispose();
        th*is.native.detach();
    }*/

    function removeAllBricks()
    {
        // repeat for all bricks in the world
        for (var i = 0; i < this._bricks.length; i++) {
            if (this._bricks[i]) {
                // destroy brick
                this._bricks[i].destroy();
                // remove the physics body
                this.destroyBody(this._bricks[i]);
            }
        }
        // zero the array
        this._bricks = new Array();
    }
    // @endregion

    // @region private functions
    function beginContact(contact)
    {
        // if the ball do not exists the contact is irrelevant - do nothing
        if (!this._ball) return;
        // get the first contact
        var current = contact;
        while (current) {
            // get the bodies in the contact
            var bodyA = current.getBodyA();
            var bodyB = current.getBodyB();
            // check if something hit the ground (it can be only ball)
            if (bodyA == this._ground || bodyB == this._ground)
                // destroy the ball
                this._bodiesToDestory.push(this._ball);
            // get the next contact (they can be more contacts during the one step)
            current = current.getNext();
        }
    }

    function endContact(contact)
    {
        // if the ball do not exists the contact is irrelevant - do nothing
        if (!this._ball) return;
        var current = contact;
        // get the first contact
        while (current) {
            // get the bodies in the contact
            var bodyA = current.getBodyA();
            var bodyB = current.getBodyB();
            var existing = this._bricks.filter(:x { return x == bodyA; }); // lamba function, the same as ".filter(function(x) { return x == bodyA; })"
            if (existing.length != 0) {
                bodyA.hit();
                if (this._enableSounds) this._wavPaddle.play();
                return;
            }
            existing = this._bricks.filter(:x { return x == bodyB; });
            if (existing.length != 0) {
                bodyB.hit();
                if (this._enableSounds) this._wavPaddle.play();
                return;
            }
            if (this._enableSounds && (bodyA == this._paddle || bodyB == this._paddle))
                this._wavBall.play();
            // get next contact
            current = current.getNext();
        }
    }

    function _createMantinels()
    {
        // Ground
        var (width, height) = (System.width, 1);
        this._ground = this.addPolygonBody(null, #static, 0.0, 0.0, 1.0, width, height); // density, friction, bounce
        this._ground.setPosition(System.width/2, System.height - (this._ground.height/2));
        
        // Left mantinel
        var (widthML, heightML) = (1, System.height);
        this._leftMantinel = this.addPolygonBody(null, #static, 0.0, 0.0, 1.0, widthML, heightML);
        this._leftMantinel.setPosition(this._leftMantinel.width/2, System.height/2);
        
        // Righ mantinel
        var (widthMR, heightMR) = (1, System.height);
        this._rightMantinel = this.addPolygonBody(null, #static, 0.0, 0.0, 1.0, widthMR, heightMR);
        this._rightMantinel.setPosition(System.width - (this._rightMantinel.width/2), System.height/2);
        
        // Top mantinel
        var (widthMT, heightMT) = (System.width, 1);
        this._topMantinel = this.addPolygonBody(null, #static, 0.0, 0.0, 1.0, widthMT, heightMT);
        this._topMantinel.setPosition(System.width/2, (this._topMantinel.height/2));
    }

    function _createPaddle()
    {
        // paddle dimensions
        var (bw, bh) = (128.0, 32.0);
        // paddle position
        this._paddleY = System.height - (System.height / 5);
        this._paddleX = System.width / 2;
        // create paddle
        this._paddle = new Disk({scene: this, enableSound : this._enableSounds});
        // place paddle
        this._paddle.setPosition(this._paddleX, this._paddleY);
        this._paddle.id = #paddle;
        return this._paddle;
    }

    function _createBall()
    {
        this._ball = new Ball({scene:this});
        this._ball.setPosition(System.width / 2, System.height / 2);
        return this._ball;
    }

    function _createBricks()
    {
        // brick dimensions
        var (brickWidth, brickHeight) = (53, 17);
        // number of brick rows
        var brickRows = 5;
        // number brick columns - depends on screen width
        var brickColumns = Math.floor( (4 * System.width / 10) / brickWidth);
        brickColumns = 2*brickColumns;
        var bricksInRows = [brickColumns - 2, brickColumns, brickColumns, brickColumns, brickColumns - 2];

        // position of first brick
        var startX = (System.width - (brickWidth*brickColumns))/2 + brickWidth/2;
        var startY = (System.height - (System.height/2) - (brickHeight*brickRows))/2;

        this._bricks = [];
        // create bricks
        for (var r = 0; r < brickRows; r++){
            // create one row
            for (var c = (brickColumns - bricksInRows[r]) / 2; c < brickColumns - (brickColumns - bricksInRows[r]) / 2; c++){
                var brickBody = new Brick({
                    scene   : this,
                    state   : rand(this.level),
                    shape   : b2PolygonShape.fromRect((brickWidth/2)/this.scale, (brickHeight/2)/this.scale)
                });
                // place the brick
                brickBody.setPosition(startX+(c*brickWidth), startY+(r*brickHeight));
                this._bricks.push(brickBody);
                this.brickCount += 1;
            }
        }
    }

    function _loadGameSounds()
    {
        // Loading sounds
        if (this._enableSounds) {
            this._wavBall = new AudioPlayer();
            this._wavBall.openFile(res.sounds.ball);
    
            this._wavPaddle = new AudioPlayer();
            this._wavPaddle.openFile(res.sounds.strikeball);
        }
    }

    function _nextLevel()
    {
        this.paused = true;
        // check if user finished the game
        if (this.level > 3)
            this._gameOver.visible = true;
        else {
            // otherwise start next level
            this._levelSprite.frame = this.level;
            this._levelSprite.show();
            this.level = this.level+1;
            this.restart();
            this._ball.visible = false;
            var delay = new Timer(1, 1);
            // timer call back function
            delay.onTick = function(sender) {
                this super.paused = false;
                this super._levelSprite.hide();
                this super._ball.visible = true;
            }
            delay.start(1500);
        }

    }

    function _removeBricks()
    {
        // Remove touched bricks
        for(var body in this._bodiesToDestory) {
            var existing = this._bricks.filter(:x { return x == body; });
            if (existing.length != 0)
                this._bricks.removeByValue(body);
                // GAME OVER
                 if (this._ball == body) {
                    this._gameStarted = false;
                    this._createBall();
                    this._paddle.setPosition( this._paddleX, this._paddleY);
                }
                this.destroyBody(body);
        }
        // zero the array
        this._bodiesToDestory = [];
    }

    function _inactiveBricks()
    {
        // inactive touched bricks
        for(var body in this._bodiesToInactive)
            body.active = false;
        // zero the array
        this._bodiesToInactive = [];
    }

    function _pulseAnimation(obj)           // fade in then pulse
    {
        obj.alpha = 1;                      // start form invisible state
        var fade = Transition.to(obj, {
            transition  : Animator.Transition.easeIn,
            duration    : 400,
            alpha       : 255,               // transparency - custom attribute
        }, false);                           // false = don't play autimatically
        var scale1 = Transition.to(obj, {
            transition  : Animator.Transition.easeInOut,
            duration    : 150,
            scale       : 0.8,              // smothly resize the object
        }, false);
        var scale2 = Transition.to(obj, {
            transition  : Animator.Transition.easeInOut,
            duration    : 200,
            scale       : 1.3,              // smothly resize the object
        }, false);
        var scale3 = Transition.to(obj, {
            transition  : Animator.Transition.easeInOut,
            duration    : 100,
            scale       : 1.0              // smothly resize the object
        }, false);
        // play all animations gradually
        new AnimatorChain([fade, scale1, scale2, scale3]).play();
    }
    // @endregion
}