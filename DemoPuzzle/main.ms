include "lib://game2d/game.ms"
include "lib://game2d/imageButton.ms"
include "app://area.ms"

var GFX_PATH = "app://gfx/";
//Create new Game instance
var app = new Game();

//Event called before run game
app.onStart = function()
{
    if ((System.width < 600) || (System.height < 900)) {
        var line1 = "Unsupported resolution! ";
        var line2 = "This game requires at least";
        var line3 = "600px width and 900px height."

        var paint = new Paint();
        paint.typeface = Typeface.fromName("", #normal);
        paint.color = 0xffffffff;
        paint.textSize = 20;

        var (w1,h1) = paint.measureText(line1);
        var (w2,h2) = paint.measureText(line2);
        var (w3,h3) = paint.measureText(line3);

        app.onDraw = function(canvas)
        {
            canvas.drawText(line1, (System.width - w1)/2, System.height/2 - h1 , paint);
            canvas.drawText(line2, (System.width - w2)/2, System.height/2 , paint);
            canvas.drawText(line3, (System.width - w3)/2, System.height/2 + h3, paint);
        }

        app.onPointerPressed = function(x, y)
        {
            this.quit();
        }

        return;
    }

    //Create scene object
    this.area = new Area();

    //Add buttons to the area
    if (System.OS_NAME != #iOS)
        this.area.addButton(GFX_PATH + "ico-close.png", System.width-57, 50, function() { app.quit() });
    this.area.addButton(GFX_PATH + "ico-refresh.png", 50, 50, function() { app.area.restart();});

    //Add scene to the game
    this.push(this.area);
}

app.onKeyPressed = function(keyCode)
{
    // for Android
    if (keyCode == #back || keyCode == #home)
        app.quit();
}

app.run();