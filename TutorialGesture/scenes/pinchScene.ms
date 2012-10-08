include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class PinchScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text:"Pinch gesture", y:System.height / 12, x:System.width/2}));

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);

        // allow pinch gesture
        game.setGesturePinch(true);

        game.onGesturePinch = function(state, scale, velocity)
        {
            var self = this super;

            self.scale = self.scale * scale;
            if (self.scale < self.minScale)
                self.scale = self.minScale;
            else if (self.scale > self.maxScale)
                self.scale = self.maxScale;
        }

        this._transitionMatrix = new Matrix();
        this.scale = 1.0;
        this.minScale = 0.2;
        this.maxScale = 5.0;
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
        this._transitionMatrix.postScale(this.scale, this.scale);

        canvas.drawBitmapMatrix(GFX.disk, this._transitionMatrix);

        canvas.restore();
    }

    function exit()
    {
        // disable rotate gesture
        game.setGesturePinch(false);
    }
}