// include framework classes
include "lib://core/log.ms";
include "lib://core/animation/transition.ms";
include "lib://game2d/game.ms";
include "lib://game2d/gameButton.ms";
include "lib://game2d/sceneTransitions/slideToBottom.ms";
include "lib://game2d/sceneTransitions/slideToTop.ms";
include "lib://box2d/physicsScene.ms";
include "lib://game2d/scene.ms"

// include project classes
include "app://scene/menuScene.ms";
include "app://scene/gameScene.ms";
include "app://resources.ms";
include "app://sprite/brick.ms";
include "app://sprite/disk.ms";
include "app://sprite/ball.ms";
include "app://sprite/level.ms";

// create new game instance
var game = new Game();
// create new instance of resources class, which contains all sources
var res = new Resources();

// prepare game instance before it runs
game.onStart = function()
{
    // create menu scene
    this.menu = new MenuScene();
    this.push(this.menu);
    // game scene will be in game variable
    this.game = null;
}

// reaction to hardware keyboard press
game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        app.quit();
}

// run the game
game.run(true);
