class Ball : PhysicsSprite
{
    function init()
    {
        super.init();

        this._paint = new Paint();
        this._paint.color = 0xffff0000;
        this.scale = 1.0;
        this._type = #half; //#full or #half
        this.z = 2;
    }

    function afterInit()
    {
        super.afterInit();
    }

    property ballType(v)
    {
        get return this._type;
        set {
            this._type = v;
            this._createFill();

        }
    }

    property color(v)
    {
        get return this._color;
        set {
            this._color = v;
            this._createFill();
        }
    }

    function _createFill()
    {
         console<<"ball type: "<<this._type<<"\n";
        if (this._type == #full) {
            this._paint.color = this._color;
            this._paint.shader = null;
        } else {
            var pts = {
                start :
                { 
                    x: System.width / 2,
                    y : -1*res.number.ballRadius,
                },
                end :
                {
                    x: System.width / 2,
                    y : res.number.ballRadius,
                }
            }
            var clrs = new Array(0xffffffff, this._color, this._color, 0xffffffff);
            var pos = new Array(0.2, 0.2, 0.8, 0.8);
            this._paint.shader = Shader.linear(pts, clrs, pos, 0);
        }
        console<<"createFill\n";
    };

    function hide()
    {
        if (this.id == #whiteBall)
            game.table.whiteBall = null;
        else
            game.table.balls.removeByValue(this);
        // create animator
        var animator = new Animator({
            transition: Animator.Transition.easeIn,     // start up slowly and then quickly speed up at the end of the animation
            duration: res.number.hideAnimDuration,      // length of animation in miliseconds
        });
        animator.addSubject(function(state) {           // state starts from 1.0 to 0.0
            this super.scale = state*1.0;
            this super.active = false;
        });
        animator.onComplete = function()
        {
            game.table.destroyBody(this super);
            if (this super.id == #whiteBall)
                game.table.createWhiteBall();
        }
       animator.reverse();
    }

    function draw(canvas)
    {
        super.draw(canvas);
        canvas.save();

        canvas.translate((this.x).toInteger(), (this.y).toInteger());
        canvas.scale(this.scale, this.scale);
        canvas.drawCircle(0, 0, res.number.ballRadius, this._paint);
        canvas.restore();
    }
}