include "lib://game2d/game.ms";
include "app://gameScene.ms";
include "app://resources.ms"

// create new instance of game
var game = new Game();
var res = new Resources();

game.onStart = function()
{
    // push scene to the game
    this.push(GameScene.create(0,-9.8, {sleep:false, enableCollisions:true, calledClass:GameScene}));
}

game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        game.quit();
}
// run game
game.run(true);