/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var box;
    var play;
    var pause;
    var stop;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        box = Bitmap.fromFile(root + "sprite.png");
        play = Bitmap.fromFile(root + "play.png");
        pause = Bitmap.fromFile(root + "pause.png");
        stop = Bitmap.fromFile(root + "stop.png");
    }
}
