include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "lib://game2d/imageButton.ms"
include "lib://game2d/label.ms"
include "app://gfx.ms"
include "app://sfx.ms"

// custom game class
class TutorialAudioPlayer : Game
{

    function start()
    {
        super.start();
        // additional initialization code goes here

        // load graphical resources
        GFX.load();
        SFX.load();

        var controls = new Scene();
        this.push(controls);
        // do nothing after the end of the song
        SFX.sound.loop(false);

        // add controlers (play)
        var playBtn = new ImageButton({
            y           : System.height / 2,
            x           : System.width / 2 - GFX.play.width / 2,
            image       : GFX.play,
            frameWidth  : GFX.play.width / 2,
            frameHeight : GFX.play.height,
        });
        // on click event (play sound)
        playBtn.onClick = function()
        {
            SFX.sound.play();
        }
        // add button to th controls
        controls.add(playBtn);

        // add controlers (pause)
        var pauseBtn = new ImageButton({
            y           : System.height / 2,
            x           : System.width / 2,
            image       : GFX.pause,
            frameWidth  : GFX.pause.width / 2,
            frameHeight : GFX.pause.height,
        });
        // on click event (play sound)
        pauseBtn.onClick = function()
        {
            SFX.sound.pause();
        }
        // add button to th controls
        controls.add(pauseBtn);

        // add controlers (stop)
        var stopBtn = new ImageButton({
            y           : System.height / 2,
            x           : System.width / 2 + GFX.stop.width / 2,
            image       : GFX.stop,
            frameWidth  : GFX.stop.width / 2,
            frameHeight : GFX.stop.height,
        });
        // on click event (play sound)
        stopBtn.onClick = function()
        {
            SFX.sound.stop();
        }
        // add button to th controls
        controls.add(stopBtn);

        this._position = new Label({
            text        : "playing: 0.00%",
            x           : System.width / 2,
            y           : 3*System.height / 4,
            textSize    : 24
        });
        controls.add(this._position);
    }

    function process()
    {
        if (SFX.sound.duration != 0) {
            var position = (SFX.sound.position * 1.0) / SFX.sound.duration * 100;
            this._position.text = String.printf("playing: %3.2f %%", position);
        }
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        // default drawings
        super.draw(canvas);
    }

    function keyPressed(key)
    {
        if (key == #back || key == #home) {
            this.quit();
        }
    }
}

// create instace and run the game
new TutorialAudioPlayer().run();
