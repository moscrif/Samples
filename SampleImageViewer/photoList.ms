include "lib://game2d/scene.ms"
include "app://photo.ms"

class PhotoList : Scene
{
    //@region system events
    function init()
    {
        super.init();

        this._photos = new Array();

        // insert all photos to the list
        for (var i = 0; i < 10; i++) {
            this._photos[i] = new Photo({photo : Bitmap.fromFile("app://imgs/img0" + i.toString() + ".jpg")});
            this._photos[i].y = System.height / 2;
        }

        this._actualPhoto = 5;
        this._leftPhoto = 4;
        this._rightPhoto = 6;

        this._photos[this._actualPhoto].x = System.width / 2;
        this._photos[this._leftPhoto].x = this._photos[this._actualPhoto].x - System.width;
        this._photos[this._rightPhoto].x = this._photos[this._actualPhoto].x + System.width;

        // add three needed photos to the scene

        this.add(this._photos[this._actualPhoto]);
        this.add(this._photos[this._leftPhoto]);
        this.add(this._photos[this._rightPhoto]);
   
        this._lastX;
        this._lastY;
        this._movementStart = 0;
        this._direction = #none;    /* #none, #left, #right */
    }

    function draw(canvas)
    {
        canvas.clear(0xff000000);

        super.draw(canvas);
    }
    // @endregion

    // @region user events
    function pointerPressed(x, y)
    {
        this._startPhotoDraging(x, y);
    }

    function pointerDragged(x, y)
    {
        this._photoDraging(x, y);
    }

    function pointerReleased(x, y)
    {
        this._photoRelease(x, y);
    }
    // @endregion

    // @region private functions
    function _startPhotoDraging(x, y)
    {
        this._lastX = x;
        this._lastY = y;

        if (this._animator != null) {
            this._animator.stop();
            this._animator = null;
        }

        // save the time when movemment starts
        this._movementStart = System.tick;
    }

    function _photoDraging(x, y)
    {
        // move last and first photo only max to the half of the screen
        if (this._actualPhoto == 0 && this._direction == #right || this._actualPhoto == this._photos.length - 1 && this._direction == #left)
            this._movePhoto((x - this._lastX)/2);
        else
            this._movePhoto(x - this._lastX);

        if (this._lastX > x)
            this._direction = #left;
        else
            this._direction = #right;
        this._lastX = x;
        this._lastY = y;
    }

    function _photoRelease(x, y)
    {
        this._finishMovement(x, y);
    }

    function _movePhoto(x)
    {
        this._photos[this._actualPhoto].x += x;
        if (this._leftPhoto != -1)
            this._photos[this._leftPhoto].x += x;
        if (this._rightPhoto != -1)
            this._photos[this._rightPhoto].x += x;
    }

    function _movePhotoTo(x)
    {
        this._photos[this._actualPhoto].x = x;
        if (this._leftPhoto != -1)
            this._photos[this._leftPhoto].x = x - System.width;
        if (this._rightPhoto != -1)
            this._photos[this._rightPhoto].x = x + System.width;
    }

    function _finishMovement()
    {
        // calculate gap between center of the screen and current photo position
        var gap = (System.width / 2 - this._photos[this._actualPhoto].x);

        // decide if return back current photo or move to next
        if ((Math.abs(gap) < System.width / 5) ||
        (this._photos[this._actualPhoto].x > System.width / 2 && this._direction != #right) ||
        (this._photos[this._actualPhoto].x < System.width / 2 && this._direction != #left) ||
        this._actualPhoto == 0 && this._direction == #right ||
        this._actualPhoto == this._photos.length - 1 && this._direction == #left)
            // return back current photo
            this._returnPhoto(gap);
        else
            // move to next photo
            this._nextPhoto(gap);
    }

    function _changePhotos(gap)
    {
        if (gap > 0) {  // move to right
            if (this._leftPhoto != -1)
                this.detach(this._photos[this._leftPhoto]);

            this._actualPhoto = this._rightPhoto;
            this._leftPhoto = this._rightPhoto - 1;

            this._photos[this._actualPhoto].x = System.width / 2;
            this._photos[this._leftPhoto].x = this._photos[this._actualPhoto].x - System.width;

            if (this._rightPhoto + 1 < this._photos.length) {
                this._rightPhoto = this._rightPhoto + 1;
                this._photos[this._rightPhoto].x = this._photos[this._actualPhoto].x + System.width;
                this.add(this._photos[this._rightPhoto]);
            } else {
                this._rightPhoto = - 1;
            }
        } else {        // move to left
            if (this._rightPhoto != -1)
                this.detach(this._photos[this._rightPhoto]);

            this._actualPhoto = this._leftPhoto;
            this._rightPhoto = this._leftPhoto + 1;

            this._photos[this._actualPhoto].x = System.width / 2;
            this._photos[this._rightPhoto].x = this._photos[this._actualPhoto].x + System.width;

             if (this._leftPhoto > 0) {
                this._leftPhoto = this._leftPhoto - 1;
                this._photos[this._leftPhoto].x = this._photos[this._actualPhoto].x - System.width;
                this.add(this._photos[this._leftPhoto]);
            } else {
                this._leftPhoto = - 1;
            }
        }

    }

    function _returnPhoto(gap)
    {
        this._animator = new Animator({
            transition : Animator.Transition.easeOut, // start up slowly and then quickly speed up at the end of the animation
            duration : 600,                     // length of animation in miliseconds
        });
        this._animator.startX = this._photos[this._actualPhoto].x;
        this._animator.addSubject(function(state)
        {
            this super._movePhotoTo((this super._animator.startX + gap*state).toInteger());
        })
        this._animator.options.onComplete = function()
        {
            this super._animator = null;
        }
        this._animator.play();
    }

    function _nextPhoto(gap)
    {
        // calculate time of animation, acording to the speed of finger movement
        var movementTime = System.tick - this._movementStart;
        var time = (1.0*movementTime / gap)*Math.abs(System.width - gap);
        if (Math.abs(time) > 800)
            time = 800;

        // set animator
        this._animator = new Animator({
            transition : Animator.Transition.easeOut,
            duration : Math.abs(time),                     // length of animation in miliseconds
        });
        this._animator.startX = this._photos[this._actualPhoto].x;
        this._animator.addSubject(function(state)
        {
            // recognize direction of movement
            if (gap > 0)
                // move to left
                this super._movePhotoTo((this super._animator.startX + (gap - System.width)*state).toInteger());
            else
                // move to right
                this super._movePhotoTo((this super._animator.startX + (System.width + gap)*state).toInteger());
        })
        this._animator.options.onComplete = function()
        {
            this super._animator = null;
            // change value of actual, left and right photo
            this super._changePhotos(gap);
        }
        this._animator.play();
    }
    // @endregion

    // @region properties
    property photos(v)
    {
        get return this._photos;
    }

    property actualPhoto(v)
    {
        get return this._photos[this._actualPhoto]
    }

    property leftPhoto(v)
    {
        get {
            if (this._leftPhoto != -1)
                return this._photos[this._leftPhoto];
            else
                return null;
        }
    }

    property rightPhoto(v)
    {
        get {
            if (this._rightPhoto != -1)
                return this._photos[this._rightPhoto];
            else
                return null;
        }
    }
    // @endregion
}