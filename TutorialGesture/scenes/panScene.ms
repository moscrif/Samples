include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class PanScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text:"Pan gesture", y:System.height / 12, x:System.width/2}));

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);

        // allow pan gesture
        game.setGesturePan(true);

        game.onGesturePan = function(state, transX, transY)
        {
            var self = this super;

            self.transX += transX;
            self.transY += transY;
        }

        this._transitionMatrix = new Matrix();
        this.transX = 0;
        this.transY = 0;
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
        
        this._transitionMatrix.setTranslate(-GFX.disk.width / 2 - this.transX, - GFX.disk.height / 2 - this.transY);

        canvas.drawBitmapMatrix(GFX.disk, this._transitionMatrix);

        canvas.restore();
    }

    function exit()
    {
        // disable rotate gesture
        game.setGesturePan(false);
    }
}