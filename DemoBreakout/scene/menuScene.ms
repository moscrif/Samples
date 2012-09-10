class MenuScene : Scene
{
    // @region constructor
    function init()
    {
        // call parents init function
        super.init();
    
        // allow tabs on the buttons. the tabs are denied when exit animation starts
        this.clickable = true;
    
        // load unnecesarry sources
        this._bg = res.img.menuBg;
        this._logo = res.img.logo;
    
        // calculate gap between two bodies
        var gap = 2*res.img.playButton.height/3;
        // calculate position of the top button
        var top = System.height - 2*res.img.playButton.height;
    
        // create and add play button to the scene
        this._btnPlay = this._createPlayButton(top);
        this.add(this._btnPlay);
        // apply pulse animation onto the button
        this._pulseAnimation(this._btnPlay);
    
        // create and add continue button to the scene
        this._btnContinue = this._createContinueButton(top + gap);
        this.add(this._btnContinue);
        // apply pulse animation onto the button
        this._pulseAnimation(this._btnContinue);
    
        // check if game do not runs on Apple devices
        if (System.OS_NAME != #iOS) {
            // create and add quit button to the scene
            this._btnQuit = this._createQuitButton(top + 2*gap);
            this.add(this._btnQuit);
            // apply pulse animation onto the button
            this._pulseAnimation(this._btnQuit);
        } else {
            // replace the play and continue button if there is not quit button
            this._btnPlay.y = this._btnContinue.y;
            this._btnContinue.y = top + 2*gap
        }
    }
    // @endregion

    // @region public fuctions
    // overwrite draw method
    function draw(canvas)
    {
        // draw and resized background image
        canvas.drawBitmapRect(this._bg, 0, 0, this._bg.width, this._bg.height, 0, 0, System.width, System.height);
        // draw logo
        canvas.drawBitmap(this._logo, (System.width - this._logo.width) / 2, System.height / 48);

        // call parents draw function which draws all other objects
        super.draw(canvas);
    }

    // apply fade effect
    function exit()
    {
        this.clickable = false;
        // create animator
        var animator = new Animator({
            transition  : Animator.Transition.easeIn,   // start up slowly and then quickly speed up at the end of the animation
            duration    : res.values.formAnimationTime, // length of animation in miliseconds
        });
        animator.addSubject(function(state) {           // state starts from 1.0 to 0.0
            var self = this super;
            self.alpha              = (state*255).toInteger();
            self._btnPlay.alpha     = (state*255).toInteger();
            self._btnContinue.alpha = (state*255).toInteger();
            if (self._btnQuit)
                self._btnQuit.alpha = (state*255).toInteger();
        })
        animator.options.onComplete = function()
        {
            var self = this super;
            self.visible = false;
        }
        // play animator
        animator.reverse();
    }

    // apply fade effect
    function enter()
    {
        this.clickable = true;
        // create animator
        var animator = new Animator({
            transition  : Animator.Transition.easeInOut,    // start up slowly and then quickly speed up at the end of the animation
            duration    : res.values.formAnimationTime,     // length of animation in miliseconds
        });
        animator.addSubject(function(state) {               // state starts from 1.0 to 0.0
            var self                = this super;
            self.alpha              = (state*255).toInteger();
            self._btnPlay.alpha     = (state*255).toInteger();
            self._btnContinue.alpha = (state*255).toInteger();
            if (self._btnQuit)
                self._btnQuit.alpha = (state*255).toInteger();
        });
        // play animator
        animator.play();
    }
    // @endregion

    // @region private functions
    //create play button
    function _createPlayButton(top)
    {
        // create new instanco of GameButton with images from the resources
        var button = new ImageButton({image: res.img.playButton, x:System.width/2, y: top, frameWidth: res.img.playButton.width, frameHeight: res.img.playButton.height / 2});
        // set onClick event - start new game
        button.onClick = function()
        {
            // create new game scene
            game.game = GameScene.create(0.0, -0.5, { calledClass: GameScene } );
            // initialize new game
            game.game.removeAllBricks();
            game.game.brickCount = 0;
            game.game.paused = true;
            game.game.visible = true;
            game.game.level = 0;
            game.game.start();
            game.push(game.game, new SlideToBottom());
        }
        return button;
    }

    // create continue button
    function _createContinueButton(top)
    {
        // create new instanco of GameButton with images from the resources
        var button = new ImageButton ({
            image       : res.img.continueButton,
            x           : System.width/2,
            y           : top,
            frameWidth  : res.img.continueButton.width,
            frameHeight : res.img.continueButton.height / 2,
        });
        button.onClick = function()
        {
            if(game.game instanceof PhysicsScene) {
                game.game.visible = true;
                game.push(game.game, new SlideToBottom());
                game.game.paused = false;
            }
        }
        return button;
    }

    function _createQuitButton(top)
    {
        // create new instanco of GameButton with images from the resources
        var button = new ImageButton({image: res.img.quitButton, x: System.width/2 , y : top, frameWidth: res.img.quitButton.width, frameHeight: res.img.quitButton.height /2 });
        // quit the game when user tap on the button
        button.onClick = function()
        {
            game.quit();
        }
        return button;
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