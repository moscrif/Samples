/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var disk;
    var zero, one, two, three, four, five, six, seven, eight, nine, dot;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        disk    = Bitmap.fromFile(root + "disk.png");
        zero    = Bitmap.fromFile(root + "0.png");
        one     = Bitmap.fromFile(root + "1.png");
        two     = Bitmap.fromFile(root + "2.png");
        three   = Bitmap.fromFile(root + "3.png");
        four    = Bitmap.fromFile(root + "4.png");
        five    = Bitmap.fromFile(root + "5.png");
        six     = Bitmap.fromFile(root + "6.png");
        seven   = Bitmap.fromFile(root + "7.png");
        eight   = Bitmap.fromFile(root + "8.png");
        nine    = Bitmap.fromFile(root + "9.png");
        dot     = Bitmap.fromFile(root + "dot.png");
    }
}
