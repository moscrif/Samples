include "lib://game2d/scene.ms";

class GameScene : Scene
{
    // background image
    var img = Bitmap.fromFile("app://menu_back.png");

    function init()
    {
        super.init();

        // resize backgorund image
        this._background = GameScene.img;
        this._background = this._background.resize(System.width, System.height);
    }

    function draw(canvas)
    {
        // draw background
        canvas.drawBitmap(this._background, 0, 0);
        // call
        super.draw(canvas);
    }
}