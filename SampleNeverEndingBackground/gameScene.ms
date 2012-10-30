include "lib://game2d/scene.ms"

class GameScene : Scene
{
    function init()
    {
        super.init();
        // add sprites, layers, etc...
        this.add(new Background());
    }

    function draw(canvas)
    {
        // custom drawings

        // call (optional) default drawings
        super.draw(canvas);
    }
}
