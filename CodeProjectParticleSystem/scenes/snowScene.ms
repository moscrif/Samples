include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

include "lib://game2d/particle/lineEmitter.ms"

class SnowScene : Scene
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
    
        this._emitter.draw(canvas)
    }

    function _createParticleSystem()
    {
        this._emitter = new LineEmitter ({
            x               : System.width / 2,
            y               : 0,
            angle           : Math.PI / 2,
            spread          : Math.PI / 8,
            emissionRate    : 12,
            speed           : 100,
            particleLife    : (System.height / 100) * 1000,
            width           : System.width,
            particleOptions : {
                image       : GFX.snow;
            }
        });
    }

    function _goBack()
    {
        this._emitter.dispose();
        Game.instance.pop(new SlideToBottom());
    }
}