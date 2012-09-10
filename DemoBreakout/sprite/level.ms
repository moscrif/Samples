include "lib://game2d/sprite.ms";

class Level : Sprite
{
    function init()
    {
       super.init();
       this.paint = new Paint();
    }

    // @region properties
    property visible(v)
    {
        get return this._visible;
        set this._visible = v;
    }
    // @endregion

    // @region public functions
    // show the sprite with an animation
    function show()
    {
        this._visible = true;
        this.paint.alpha = 255;
        this._pulseAnimation(this);
    }

    // hide sprite with some animation
    function hide()
    {
        var animator = new Animator({
            transition: Animator.Transition.easeIn, // start up slowly and then quickly speed up at the end of the animation
            duration: 1500,                         // length of animation in miliseconds
        });
        animator.addSubject(function(state) {       // state starts from 1.0 to 0.0
           this super.paint.alpha = (state*255).toInteger();
        })
        animator.onComplete = function()
        {
            this super.visible = false;
        }
        animator.reverse();
    }
    // @endregion

    // @region private functions
    function _pulseAnimation(obj)
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