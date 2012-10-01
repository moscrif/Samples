include "lib://game2d/base/sceneTransition.ms";

class OwnTransition : SceneTransition
{
    function init()
    {
        super.init();
        this._scale = 0;
    }

    // @region public fuctions
    function draw(canvas)
    {
        super.draw(canvas);
        // draw initial scene
        if (this._sceneFrom) {
            canvas.save();
            this._sceneFrom.draw(canvas);
            canvas.restore();
        }
        // draw end scene
        if (this._sceneTo) {
            canvas.save();
            // scaled and centered new scene
            canvas.translate(System.width / 2 - (System.width / 2*this._scale).toInteger(), System.height / 2 - (System.height / 2*this._scale).toInteger());
            canvas.scale(this._scale, this._scale);
            this._sceneTo.draw(canvas);
            canvas.restore();
        }
    }

    // sets local variables according to animation state
    function setState(value)
    {
        this._scale = value * 1.0;
        super.setState(value);
    }
    // @endregion
}