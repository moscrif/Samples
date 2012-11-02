include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"
include "app://sfx.ms"
include "app://scenes/singlePlayerScene.ms"

// custom game class
class SampleTetris : Game
{
    function start()
    {
        super.start();

        // load graphical resources
        GFX.load();

        // load sound and musics
        SFX.load();

        // add menu scene
        this.push(new SinglePlayerScene());
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        // default drawings
        super.draw(canvas);
    }


}

var game = new SampleTetris();

game.onKeyPressed = function(keyCode)
{console<<"klik\n";
    if (keyCode == #back || keyCode == #home) {
        this.quit();
    }
}
// create instace and run the game
game.run();
