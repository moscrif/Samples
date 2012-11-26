include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"
include "app://sfx.ms"
include "app://scenes/dialogScene.ms"

var facebook = null;

// custom game class
class TutorialFacebook : Game
{

    function start()
    {
        super.start();
        // load graphical resources
        GFX.load();

        // load sound and musics
        SFX.load();

        // get acces to the facebook
        facebook = new Facebook("YOUR OWN APP ID", ["offline_access", "status_update", "read_stream", "publish_stream", "publish_actions"]);
        if(!facebook) {
            System.messageBox("Could not create a facebook client!!");
            return;
        }

        // add menu scene
        this.push(new DialogScene());

    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        // default drawings
        super.draw(canvas);
    }

    function keyPressed()
    {
        this.quit();
    }

}

// create instace and run the game
new TutorialFacebook().run();
