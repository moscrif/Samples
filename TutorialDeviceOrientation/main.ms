include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"
include "app://sfx.ms"
include "app://scenes/menuScene.ms"

var currentOrientation = #portail;

// custom game class
class TutorialDeviceOrientation : Game
{

    function start()
    {
        super.start();

        // load graphical resources
        GFX.load();

        // load sound and musics
        SFX.load();

        // supported orientations
        this.orientation = [#portrait, #landscape-left, #landscape-right];
        this.bg = GFX.background;

        // add menu scene
        this.push(new MenuScene());
    }

   /* function process()
    {
        console<<this.orientation<<"orientation\n";
    }
*/
    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(this.bg, 0, 0);

        // default drawings
        super.draw(canvas);
    }

}

// create instace and run the game
new TutorialDeviceOrientation().run();
