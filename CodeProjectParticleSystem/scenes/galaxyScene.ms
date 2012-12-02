include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

include "lib://game2d/particle/lineEmitter.ms"

class GalaxyScene : Scene
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
    }

    function draw(canvas)
    {
        super.draw(canvas);
    
        this._emitterA.draw(canvas);
        this._emitterB.draw(canvas);
        this._emitterC.draw(canvas);
        this._emitterD.draw(canvas);
    }

    function process()
    {
        this._emitterA.angle += 0.07;
        this._emitterB.angle += 0.07;
        this._emitterC.angle += 0.07;
        this._emitterD.angle += 0.07;
    }

    function _createParticleSystem()
    {
        this._emitterA = new PointEmitter({
            x : System.width / 2,
            y : System.height / 2,
            speed : 400,
            angle : Math.PI / 2,
            spread : Math.PI / 8,
            particleLife : 1000,
            emissionRate : 30,
            particleOptions : {
                image : GFX.starSmall
            }
        });
        this._emitterB = new PointEmitter({
            x : System.width / 2,
            y : System.height / 2,
            speed : 400,
            angle : Math.PI,
            spread : Math.PI / 8,
            particleLife : 1000,
            emissionRate : 30,
            particleOptions : {
                image : GFX.starSmall
            }
        });
        this._emitterC = new PointEmitter({
            x : System.width / 2,
            y : System.height / 2,
            speed : 400,
            angle : 3*Math.PI / 2,
            spread : Math.PI / 8,
            particleLife : 1000,
            emissionRate : 30,
            particleOptions : {
                image : GFX.starSmall
            }
        });
        this._emitterD = new PointEmitter({
            x : System.width / 2,
            y : System.height / 2,
            speed : 400,
            angle : 2*Math.PI,
            spread : Math.PI / 8,
            particleLife : 1000,
            emissionRate : 30,
            particleOptions : {
                image : GFX.starSmall
            }
        });
    }

    function _goBack()
    {
        this._emitterA.dispose();
        this._emitterB.dispose();
        this._emitterC.dispose();
        this._emitterD.dispose();
        Game.instance.pop(new SlideToBottom());
    }
}