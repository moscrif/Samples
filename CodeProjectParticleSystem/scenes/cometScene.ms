include "lib://game2d/textButton.ms"
include "lib://game2d/particle/field.ms"

include "app://customParticle.ms"

class CometScene : Scene
{
    function init()
    {
        super.init();

        this._createParticleSystem();

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            this super._goBack();
        }
        this.add(this._back);

        this._lastX = 0;
        this._lastY = 0;
    }

    function draw(canvas)
    {
        super.draw(canvas);

        this._emitter.draw(canvas);
    }

    function _createParticleSystem()
    {
        this._emitter = new PointEmitter({
            x : System.width / 2,
            y : System.height / 2,
            speed : 600,
            angle : 5*Math.PI / 4,
            spread : Math.PI / 8,
            particleLife : 1100,
            emissionRate : 50,
            particleClass : CustomParticle,
        });
    }

    function pointerDragged(x, y)
    {
        this._emitter.moveTo(x, y);
    }

    function _goBack()
    {
        this._emitter.dispose();
        Game.instance.pop(new SlideToBottom());
    }
}