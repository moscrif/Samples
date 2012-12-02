include "lib://game2d/textButton.ms"
include "lib://game2d/particle/field.ms"

include "app://customParticle.ms"
include "app://fireEmitter.ms"

class FireScene : Scene
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
        this._emitter = new FireEmitter({
            x : System.width / 2,
            y : 7*System.height / 10,
            speed : 600,
            angle : 3*Math.PI / 2,
            spread : Math.PI /6,
            particleLife : 400,
            emissionRate : 300,
            width : 80,
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