include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/singlePlayerScene.ms"
include "app://scenes/multiPlayerScene.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        MenuScene.instance = this;

        Game.instance.onOrientationChanged = function(orientation)
        {
            this super.replaceControls(orientation);
        }

        this._singlePlayer = new TextButton({text:"Single Player"});
        this._singlePlayer.onClick = function() {
            SFX.playClick();
            this super._playSinglePlayer();
        }
        this.add(this._singlePlayer);

        this._multiPlayer = new TextButton({text:"Multi Player"});
        this._multiPlayer.onClick = function() {
            SFX.playClick();
            this super._playMultiPlayer();
        }
        this.add(this._multiPlayer);

        this.replaceControls(#portrait);
    }

    function replaceControls(orientation)
    {
        currentOrientation = orientation;
        this._singlePlayer.x = System.width / 2;
        this._singlePlayer.y = 8 * System.height / 10;
        this._multiPlayer.x = System.width / 2;
        this._multiPlayer.y = 9 * System.height / 10;

        if (currentOrientation == #portrait)
            Game.instance.bg = GFX.background;
        else
            Game.instance.bg = GFX.backgroundLandscape;
    }

    function _playSinglePlayer()
    {
        Game.instance.push(new SinglePlayerScene(), new SlideToTop());
    }

    function _playMultiPlayer()
    {
        Game.instance.push(new MultiPlayerScene(), new SlideToTop());
    }

}
