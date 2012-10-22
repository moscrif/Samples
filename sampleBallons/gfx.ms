/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var disk;
    var grass;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        disk = Bitmap.fromFile(root + "disk.png");
        grass = Bitmap.fromFile(root + "grass.png");
        grass = grass.resize(System.width, System.height / 5);
    }
}
