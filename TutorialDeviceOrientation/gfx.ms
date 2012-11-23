/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var backgroundLandscape;
    var disk;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        backgroundLandscape = Bitmap.fromFile(root + "background-landscape.jpg").resize(System.height + 1, System.width + 1);
        disk = Bitmap.fromFile(root + "disk.png");
    }
}
