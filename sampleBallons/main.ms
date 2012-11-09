include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "lib://box2d/physicsScene.ms"
include "app://gfx.ms"
include "app://sfx.ms"
include "app://scenes/menuScene.ms"
include "app://leaderboard.ms"

// custom game class
class SampleBallons : Game
{
    function start()
    {
        super.start();

        // load graphical resources
        GFX.load();

        // load sound and musics
        SFX.load();

        // add menu scene
        this.push(new MenuScene());
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        // default drawings
        super.draw(canvas);
    }

    function onKeyPressed(keyCode)
    {
        if (keyCode == #back || keyCode == #home) {
            logI("Quit");
            MyGame.quit();
        }
    }

}

// create instace and run the game
new SampleBallons().run();
