/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var disk;
    var tiles;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        disk = Bitmap.fromFile(root + "disk.png");
        tiles = Bitmap.fromFile(root + "tiles.png").resize(90, 60);
    }
}
