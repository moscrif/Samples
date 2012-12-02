include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"

// particle system source files
include "lib://game2d/particle/pointEmitter.ms"
include "lib://game2d/particle/particle.ms"

include "app://scenes/menuScene.ms"


// custom game class
class CodeProjectParticleSystem : Game
{

    function start()
    {
        super.start();

        // load graphical resources
        GFX.load();

        // add menu scene
        this.push(new MenuScene());

        this._fpsPaint = new Paint();
        this._fpsPaint.color = 0xffffffff;
        this._fpsPaint.textSize = System.height / 40;
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        canvas.drawText(String.printf("FPS: %.2f", System.avgFPS), 10, System.height / 25, this._fpsPaint);

        // default drawings
        super.draw(canvas);
    }

}

// create instace and run the game
new CodeProjectParticleSystem().run(true);
