include "lib://game2d/game.ms"
include "lib://box2d/physicsScene.ms"
include "lib://game2d/layer.ms"
include "lib://game2d/imageButton.ms"

include "app://gameScene.ms"
include "app://resources.ms"
include "app://ball.ms"
include "app://forceBar.ms"

// create new instance of game
var game = new Game();
var res = new Resources();

game.onStart = function()
{
    // push scene to the game
    this.table = new GameScene();
    this.push(this.table);
}

game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        game.quit();
}

// run game
game.run(true);