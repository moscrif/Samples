//class CustomParticle - used by comet effect emitter
class CustomParticle : Particle
{
    // static variables
    // static paint used by all instances to draw bitmap

    function init()
    {
        super.init();

        // create paint used to bitmap effect
        this._paint = new Paint();
        this._paint.alpha = 80;

        // create animator
        var animator = new Animator({
            transition: Animator.Transition.easeIn,     // start up slowly and then quickly speed up at the end of the animation
            duration: 1100,                              // length of animation in miliseconds
        }); 
        animator.addSubject(function(state) {           // state starts from 1.0 to 0.0
            this super._paint.alpha = 255-(state*255).toInteger();
        }); 
        animator.play();
    }

    function draw(canvas)
    {
        canvas.drawBitmap(GFX.star, (this.x).toInteger() - GFX.star.width / 2, (this.y).toInteger() - GFX.star.height / 2, this._paint);
    }
}