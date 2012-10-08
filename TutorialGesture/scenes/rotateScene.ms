include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class RotateScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text:"Rotate gesture", y:System.height / 12, x:System.width/2}));

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);

        // allow rotate gesture
        game.setGestureRotate(true);

        game.onGestureRotate = function(state, angle, velocity)
        {
            var self = this super;

            this.state = state;
            // do not return the angle to zero, when touch is released
            if (state != #ended) {
                // radians to degrees
                self.angle -= self.lastRotation - angle * 180.0/ Math.PI;
                self.lastRotation = angle * 180.0/ Math.PI;
            } else {
                self.lastRotation = 0;
            }
        }

        this._transitionMatrix = new Matrix();
        this.angle = 0;
        this.lastRotation = 0;
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

    function draw(canvas)
    {
        super.draw(canvas);

        canvas.save();
        canvas.translate(System.width / 2, System.height / 2);
        
        this._transitionMatrix.setTranslate(-GFX.disk.width / 2, - GFX.disk.height / 2);
        this._transitionMatrix.postRotate(this.angle);

        canvas.drawBitmapMatrix(GFX.disk, this._transitionMatrix);

        canvas.restore();
    }

    function exit()
    {
        // disable rotate gesture
        game.setGestureRotate(false);
    }
}