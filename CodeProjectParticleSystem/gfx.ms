/**
This class manages graphical resources such as bitmaps, vectors etc.
*/
class GFX
{
    const root = "app://gfx/";

    var background;
    var star, starSmall, flame1, flame2, flame3, flame4, flame5, snow, rFlame, yFlame, wFlame;

    function load()
    {
        background = Bitmap.fromFile(root + "background.jpg").resize(System.width + 1, System.height + 1);
        starSmall = Bitmap.fromFile(root + "starSmall.png");
        star = Bitmap.fromFile(root + "star.png");
        flame1 = Bitmap.fromFile(root + "Flame_1.png");
        flame2 = Bitmap.fromFile(root + "Flame_2.png");
        flame3 = Bitmap.fromFile(root + "Flame_3.png");
        flame4 = Bitmap.fromFile(root + "Flame_4.png");
        flame5 = Bitmap.fromFile(root + "Flame_5.png");
        snow = Bitmap.fromFile(root + "snow.png");
        rFlame = Bitmap.fromFile(root + "redFlame.png");
        yFlame = Bitmap.fromFile(root + "yelowFlame.png");
        wFlame = Bitmap.fromFile(root + "whiteFlame.png");
    }
}
