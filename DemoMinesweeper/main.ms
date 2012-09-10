include "lib://game2d/game.ms"
include "lib://game2d/sprite.ms"
include "lib://game2d/layer.ms"
include "lib://game2d/textButton.ms"

include "app://resources.ms"
include "app://gameScene.ms"
include "app://minesCounter.ms"
include "app://timerSprite.ms"
include "app://mineCell.ms"
include "app://menu.ms"

var game = new Game();
var res = new Resources();

game.onStart = function()
{
    this._game = new GameScene();
    this.push(this._game);
}

game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        game.quit();
}

game.run();