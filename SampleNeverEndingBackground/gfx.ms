/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var star;

    function load()
    {
        star = Bitmap.fromFile(root + "star.png");
    }
}
