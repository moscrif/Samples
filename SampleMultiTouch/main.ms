include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"

// custom game class
class SampleMultiTouch : Game
{
    function start()
    {
        super.start();

        // load graphical resources
        GFX.load();

        // allow multi touch
        this.multiTouch = true;

        this.circle = new Paint();
        this.circle.color = 0x55000000;

        this.coordinates = new Array();
    }

    function pointerPressed(x, y, index)
    {
        // if multi touch is not supported save only one touch
        if (index == -1)
            index = 0;
    
        // save touch coordinates
        this.coordinates[index] = {
            x   : x,
            y   : y,
        }
    }

    function pointerDragged(x, y, index)
    {
        // if multi touch is not supported save only one touch
        if (index == -1)
            index = 0;
    
        // update coordinates
        if (this.coordinates[index]) {
            this.coordinates[index].x = x;
            this.coordinates[index].y = y;
        } else {
            this.coordinates[index] = {
                x   : x,
                y   : y,
            }
        }
    }

    function pointerReleased(x, y, index)
    {
        // if multi touch is not supported save only one touch
        if (index == -1)
            index = 0;

        // remove coordinates
        if (this.coordinates[index])
            this.coordinates.remove(index);
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        super.draw(canvas);

        var radius = System.width / 7;
        for (var i in this.coordinates) {
            canvas.drawCircle(i.x, i.y, radius, this.circle);
        }
    }
}

// create instace and run the game
new SampleMultiTouch().run();
