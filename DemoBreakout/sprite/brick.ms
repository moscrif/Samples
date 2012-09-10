include "lib://box2d/physicsSprite.ms";

class Brick : PhysicsSprite
{
    function init()
    {
        super.init();
        this.state = 1;
    
        //image brigs.png
        this.image = res.img.brisks;
        this.frameWidth = 53;
        this.frameHeight = 17;
    
        this.bodyType = #static;
        this.density = 0.0;
        this.friction = 0.0;
        this.bounce = 0.1;
    
        //decoration object
        this._paint = new Paint();
        this._paint.alpha = 0;
        this.disabled = false;
        this.show(this);
    }

    function afterInit()
    {
        super.afterInit();
        // create physics body
        this._createBody();
    }

    // @region properties
    property state(v)
    {
        get return this._state;
        set {
            this.frame = v;
            this._state = v;
        }
    }
    // @endregion

    // @region public functions
    function hit()
    {
        if (this.disabled == false)
            // disable brick if tis state (level) is less then one
            if (this.state < 1) {
                this.disabled = true;
                this.scene.brickCount--;
                this.hide(this);
            // decrease the brick's state (level)
            } else {
                this.state -= 1;
            }
    }

    // animate brick wehn it is shown
    function show(obj)
    {
        // create animator
        var animator = new Animator({
            transition: Animator.Transition.easeIn,     // start up slowly and then quickly speed up at the end of the animation
            duration: 500,                              // length of animation in miliseconds
        });
        animator.addSubject(function(state) {           // state starts from 1.0 to 0.0
            obj._paint.alpha = 255-(state*255).toInteger();
        });
       animator.reverse();
    }

    // animate brick when is is going to be hide
    function hide(obj)
    {
        // inactivate the body
        this.scene._bodiesToInactive.push(this);
        // create animator
        var animator = new Animator({
            transition: Animator.Transition.easeOut,    // start up slowly and then quickly speed up at the end of the animation
            duration: 500,                             // length of animation in miliseconds
        });
        animator.addSubject(function(state) {           // state starts from 1.0 to 0.0
            obj._paint.alpha = 255-(state*255).toInteger();
        });
        animator.options.onComplete = function() {
            this super.scene._bodiesToDestory.push(this super);
        }
        animator.play();
    }

    // "destroy" the body
    function destroy()
    {
        // decrease the number of bricks
        this.scene.brickCount -= 1;
    }

}