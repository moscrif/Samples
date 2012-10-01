include "lib://game2d/game.ms"
include "lib://box2d/physicsScene.ms"

include "app://gameScene.ms"

// create new instance of Game class
var game = new Game();

game.onStart = function()
{
    // create new scane
    var scene = new GameScene();
    // push scene into the game
    this.push(scene);
}

// quit game when user click to back or home button
game.onKeyPressed = function(keyCode)
{
    // check key code if back or home button was pressed
    if (keyCode == #back || keyCode == #menu)
        // quit game
        game.quit();
}

// run application
game.run();