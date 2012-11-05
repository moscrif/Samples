include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"
include "app://background.ms"
include "app://gameScene.ms"

// custom game class
class SampleNeverEndingBackground : Game
{
    function start()
    {
        super.start();

        // load graphical resources
        GFX.load();

        // additional initialization code goes here
        this.push(new GameScene());
    }

    function keyPressed(key)
    {
        if (key == #back || key == #home) {
            this.quit();
        }
    }
}

// create instace and run the game
new SampleNeverEndingBackground().run();