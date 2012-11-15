include "lib://game2d/sprite.ms"

class GameCharacter : Sprite
{
    function init()
    {
        // call parents init method
        super.init();
        // set start position
        this.x = System.width / 2;
        this.y = System.height / 2;
        // set image with frames
        this.image = GFX.sprite;
        // split image to the frames
        this.frameWidth = GFX.sprite.width / 8;
        this.frameHeight = GFX.sprite.height / 3;
        // split frames into the sequences
        this._sequences = {
            left : [0, 1, 2, 3, 4, 5, 6, 7],
            right : [8, 9, 10, 11, 12, 13, 14, 15],
            wait : [16, 17, 18, 19, 20, 21, 22, 23]
        }

        this.action = #wait;   // #wait / #right or #left
        // number of frames in one secondd
        this.fps = 10;
        this._timeGap = 1000/this.fps;
        this._lastFrameChange = System.tick;
        // movement on the horizontal axis in pixels
        this.step = 3;  // px
    }

    property action(v)
    {
        get return this._action;
        set {
            // change sequence
            this.sequence = this._sequences[v];
            this._action = v;
        }
    }

    function process()
    {
        // change if it is time to change the frame
        if (System.tick - this._lastFrameChange > this._timeGap) {
            // move to the next frame
            this.nextFrame();
            // save current time
            this._lastFrameChange = System.tick;
    
            // move on horizontal axis to the left
            if (this.action == #left)
                // do not move out of the screen
                if (this.x < this.frameWidth)
                    this.action = #wait;
                else
                    this.x -= this.step;
            // move on horizontal axis to the right
            else if (this.action == #right)
                // do not move out of the screen
                if (this.x > System.width - this.frameWidth) {
                    this.action = #wait;
                    this.frame = 4;
                } else
                    this.x += this.step;
        }
    }
}