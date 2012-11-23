include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class SinglePlayerScene : Scene
{
    function init()
    {
        super.init();

        Game.instance.onOrientationChanged = function(orientation)
        {
            this super.replaceControls(orientation);
            if (MenuScene.instance)
                MenuScene.instance.replaceControls(orientation);
        }

        this._label = new Label({text:"Single Player", y:200, x:System.width/2});
        this.add(this._label);

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);
    }

    function replaceControls(orientation)
    {
        currentOrientation = orientation;
        this._label.x = System.width / 2;
        this._label.y = 200;
        this._back.x = System.width / 2;
        this._back.y = 9 * System.height / 10;
        if (currentOrientation == #portrait)
            Game.instance.bg = GFX.background;
        else
            Game.instance.bg = GFX.backgroundLandscape;
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

}
