/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var sprite;
    var left;
    var right;
    var stop;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        sprite = Bitmap.fromFile(root + "sprite.png");
        left = Bitmap.fromFile(root + "left.png");
        right = Bitmap.fromFile(root + "right.png");
        stop = Bitmap.fromFile(root + "stop.png");
    }
}
