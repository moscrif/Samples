include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/singlePlayerScene.ms"
include "app://scenes/scoreScene.ms"

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

        this._score = new TextButton({text:"High score", x:System.width/2, y:System.height/10*9});
        this._score.onClick = function() {
            SFX.playClick();
            this super._doScore();
        }
        this.add(this._score);
    }

    function _playSinglePlayer()
    {
        Game.instance.push(new SinglePlayerScene(), new SlideToTop());
    }

    function _doScore()
    {
        Game.instance.push(new ScoreScene(), new SlideToTop());
    }
}