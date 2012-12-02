include "lib://game2d/textButton.ms"
include "lib://game2d/particle/field.ms"

include "app://customParticle.ms"
include "app://fireEmitter2.ms"

class FireScene2 : Scene
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

        this._emitterA.draw(canvas);
        this._emitterB.draw(canvas);
        this._emitterC.draw(canvas);
    }

    function _createParticleSystem()
    {
        this._emitterA = new FireEmitter2({
            x : System.width / 2,
            y : 7*System.height / 10,
            speed : 600,
            angle : 3*Math.PI / 2,
            spread : Math.PI / 5,
            particleLife : 300,
            emissionRate : 500,
            width : 100,
            particleOptions : {
                image : GFX.rFlame,
            }
        });
        this._emitterB = new FireEmitter2({
            x : System.width / 2,
            y : 7*System.height / 10,
            speed : 600,
            angle : 3*Math.PI / 2,
            spread : Math.PI /6,
            particleLife : 150,
            emissionRate : 300,
            width : 80,
            particleOptions : {
                image : GFX.yFlame,
            }
        });
        this._emitterC = new FireEmitter2({
            x : System.width / 2,
            y : 7*System.height / 10,
            speed : 600,
            angle : 3*Math.PI / 2,
            spread : Math.PI /6,
            particleLife : 80,
            emissionRate : 250,
            width : 50,
            particleOptions : {
                image : GFX.wFlame,
            }
        });
    }



    function _goBack()
    {
        this._emitterA.dispose();
        this._emitterB.dispose();
        this._emitterC.dispose();
        Game.instance.pop(new SlideToBottom());
    }
}