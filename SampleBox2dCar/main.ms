include "lib://game2d/game.ms"
include "lib://box2d/physicsScene.ms"
include "lib://box2d/physicsSprite.ms"
include "lib://game2d/imageButton.ms"
include "lib://game2d/layer.ms"
include "lib://core/log.ms"
//enableDebugging = false;

include "app://gameScene.ms"
include "app://car.ms"
include "app://menu.ms"

var game = new Game();

game.onStart = function()
{
    this.push(new GameScene());
}

game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        game.quit();
}

game.run();