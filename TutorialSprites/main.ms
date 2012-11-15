include "lib://core/log.ms"
include "lib://game2d/game.ms"

include "app://gfx.ms"
include "app://gameCharacter.ms"

// custom game class
class TutorialSprites : Game
{

    function start()
    {
        super.start();
        // additional initialization code goes here

        // load graphical resources
        GFX.load();

        // prepare game
        this._character = new GameCharacter()
        this.add(this._character);
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        canvas.drawBitmap(GFX.left, 10, System.height - GFX.left.height - 10);
        canvas.drawBitmap(GFX.stop, (System.width - GFX.stop.width ) / 2, System.height - GFX.left.height - 10);
        canvas.drawBitmap(GFX.right, System.width - GFX.right.width - 10, System.height - GFX.left.height - 10);

        // default drawings
        super.draw(canvas);
    }

    // change sprite action acording to tap position
    function pointerPressed(x, y)
    {
        var position = x / (System.width / 3);
        switch (position) {
            case 0:
                this._character.action = #left;
                break;
            case 1:
                this._character.action = #wait;
                break;
            case 2:
                this._character.action = #right;
                break;
        }
    }

    function keyPressed(key)
    {
        if (key == #back || key == #home) {
            this.quit();
        }
    }
}

// create instace and run the game
new TutorialSprites().run();
