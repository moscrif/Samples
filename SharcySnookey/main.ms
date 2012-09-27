include "lib://game2d/game.ms"
include "lib://game2d/scene.ms"
include "lib://game2d/tiledLayer.ms"

include "app://level.ms"
include "app://levels/level1.ms"
include "app://levels/level2.ms"
include "app://levels/level3.ms"
include "app://levels/level4.ms"
include "app://levels/level5.ms"
include "app://levels/level6.ms"
include "app://player.ms"
include "app://AI.ms"
// include level arrays
include "app://levels.ms"

var game = new Game();

game.onStart = function()
{
    this.push(new Level1());
}

game.onKeyPressed = function(key)
{
    if (key == #back || key == #menu)
        game.quit();
}

game.run();