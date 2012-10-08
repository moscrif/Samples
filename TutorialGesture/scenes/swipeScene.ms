include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class SwipeScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text:"Swipe gesture", y:System.height / 12, x:System.width/2}));

        this.label = new Label({text:"direction: none", y:System.height / 5, x:System.width/2});
        this.add(this.label);

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);

        // allow swipe gesture 1 touch all directions
        game.setGestureSwipe(true, 1, #all);

        game.onGestureSwipe = function(direction)
        {
            var self = this super;

            self.label.text = "direction: " + direction.toString();
        }
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

    function exit()
    {
        // disable swipe gesture
        game.setGestureSwipe(false, 0, 0);
    }
}