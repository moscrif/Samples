class Menu : Layer
{
    function init()
    {
        super.init();

        this._text = "";
        this._timeString = "";
        this._scene = null;

        this.showed = false;

        this.textWidth = 0;
        this.textHeight = 0;

        this.timeWidth = 0;
        this.timeHeight = 0;

        this.text = "";
        this.time = "11:22";

        this._createButtons();
    }

    property width(v)
    {
        get return this._width;
        set {
            this._width = v;
            this._anchorX = v / 2;
        }
    }

    property height(v)
    {
        get return this._height;
        set {
            this._height = v;
            this._anchorY = v / 2;
        }
    }

    property y(v)
    {
        get return this._y;
        set {
            this._y = v;
            this._newGame.y = v + 3*res.integers.menuHeight / 8;
            this._restartGame.y = v + 3*res.integers.menuHeight / 8;
            // quit button is not on iOS devices
            if (System.OS_NAME != #iOS)
                this._quitGame.y = v + 3*res.integers.menuHeight / 8;
        }
    }

    property text(v)
    {
        set {
            this._text = v;
            var (w, h) = res.paints.menuText.measureText(v);
            this.textWidth = w;
            this.textHeight = h;
        }
    }

    property time(v)
    {
        get { return this.timeString;}
        set {
            this._timeString = v;
            var (w, h) = res.paints.menuTime.measureText("00:00");
            this.timeWidth = w;
            this.timeHeight = h;
        }
    }

    property scene(v)
    {
        get return this._scene;
        set this._scene = v;
    }

    function draw(canvas)
    {
        canvas.save();
        canvas.translate(this.x, this.y);

        // draw background
        canvas.drawPath(res.vectors.menuShadow, res.paints.menuShadow);
        canvas.drawPath(res.vectors.menuPart, res.paints.menu);
        canvas.drawRect(System.width / -2, res.integers.menuHeight / - 2, System.width / 2, 7*res.integers.menuHeight / 20, res.paints.menu);

        // draw text
        canvas.drawText(this._timeString, this.timeWidth / -2, this.timeHeight / -2, res.paints.menuTime);
        canvas.drawText(this._text, this.textWidth / -2, this.timeHeight / 2, res.paints.menuText);

        canvas.restore();

        super.draw(canvas);
    }

    function show()
    {
        var animator = new Animator({
            transition: Animator.Transition.easeInOut,
            duration: res.integers.menuAnimationDuration,       // length of animation in miliseconds
        });
        animator.addSubject(function(state) {       // state starts from 1.0 to 0.0
            this super.y = res.integers.menuHeight / -4 + state * 3* res.integers.menuHeight / 4;
        });
        animator.onComplete = function()
        {
            this super.showed = true;
        }
        animator.play();
    }

    function hide()
    {
        var animator = new Animator({
            transition: Animator.Transition.easeInOut,
            duration: res.integers.menuAnimationDuration,       // length of animation in miliseconds
        });
        animator.addSubject(function(state) {       // state starts from 1.0 to 0.0
            this super.y = res.integers.menuHeight / -4 + state * 3* res.integers.menuHeight / 4;
        });
        animator.onComplete = function()
        {
            this super.showed = false;
        }
        animator.reverse();
    }

    function _createButtons()
    {
        var buttonGap = System.width / 15;
        var buttonWidth = (System.width - 2 * buttonGap) / 3;

        if (System.OS_NAME != #iOS) {
            this._newGame = new TextButton({
                text    : "Start new game",
                x       : System.width / 2,
                paint   : res.paints.buttonText,
                width : System.width / 2,
                height : System.height / 2,
               // anchorX : System.width / 2,

            });
            this._newGame.onClick = function()
            {
                this super.scene.newGame();
            }
            this.add(this._newGame);
            // restart button
            this._restartGame = new TextButton({
                text    : "Restart",
                x       : buttonGap + buttonWidth / 2,
                width   : buttonWidth,
                paint   : res.paints.buttonText,
            });
            this._restartGame.onClick = function()
            {
                this super.scene.restart();
            }
            this.add(this._restartGame);
            // quit button
            this._quitGame = new TextButton({
                text    : "Quit",
                x       : buttonGap + 2*buttonWidth + buttonWidth / 2,
                width   : buttonWidth,
                y       : res.integers.menuHeight / 8,
                paint   : res.paints.buttonQuitText,
            });
            this._quitGame.onClick = function()
            {
                game.quit();
            }
            this.add(this._quitGame);
        } else {
            buttonWidth = System.width / 2 - buttonGap;
            this._newGame = new TextButton({
                text    : "Start new game",
                x       : buttonGap + buttonWidth / 2,
                width   : buttonWidth,
                paint   : res.paints.buttonText,
            });
            this._newGame.onClick = function()
            {
                this super.scene.newGame();
            }
            this.add(this._newGame);
            // restart button
            this._restartGame = new TextButton({
                text    : "Restart",
                x       : buttonGap + buttonWidth + buttonWidth/ 2,
                width   : buttonWidth,
                paint   : res.paints.buttonText,
            });
            this._restartGame.onClick = function()
            {
                this super.scene.restart();
            }
            this.add(this._restartGame);
            this._quitGame = 0;
        }
    }
}