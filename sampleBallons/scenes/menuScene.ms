include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/singlePlayerScene.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this._singlePlayer = new TextButton({text:"Game", x:System.width/2, y:System.height/10*8});
        this._singlePlayer.onClick = function() {
            SFX.playClick();
            this super._playSinglePlayer();
        }
        this.add(this._singlePlayer);
    }

    function _playSinglePlayer()
    {
        Game.instance.push(new SinglePlayerScene(), new SlideToTop());
    }
}