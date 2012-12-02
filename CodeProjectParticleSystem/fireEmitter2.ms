include "lib://game2d/particle/lineEmitter.ms"

class FireEmitter2 : LineEmitter
{
    function init()
    {
        super.init();

      //  this._particleImages = [GFX.flame1, GFX.flame2, GFX.flame3, GFX.flame4, GFX.flame5];
    }

    property width(v)
    {
        get return this._width;
        set {
            assert v instanceof Integer;
            this._width = v;
        }
    }

    function _timeStep()
    {
        var particle;
        for (particle in this._particles) {
            if (this._particleLife != -1 && particle._age > 2*this._particleLife / 4 && (rand(10) > 6 || particle._age > this._particleLife)) {

                    this._particles.removeByValue(particle);
            } else {
                if (this._fields != null && this._fields.length > 0)
                    particle.move(1000 / this._stepsPerSeconds, this._fields);
                else
                    particle.move(1000 / this._stepsPerSeconds);
            }
        }

        var number = this._emissionRate * 1.0 / this._stepsPerSeconds;
        if (number > 0.9)
            for (var i = 0; i < (number).toInteger(); i++)
                this._addParticle();
        else {
            this._i += number;
            if (this._i > 1.0) {
                this._addParticle();
                this._i = 0.0;
            }

        }
    }

   /* function _addParticle(options = null)
    {
        if (this._maxParticles > 0 && this._particles.length >= this._maxParticles)
            return;
        var self = this;

        var clazz = this.particleClass;
        var particle = new clazz(this._particleOptions);

        var c = rand(this._width) - this._width / 2;
        particle.x = this.x + Math.sin(this._angle ) * c;
        particle.y = this.y + Math.cos(this._angle) * c;
        
        var angle = this._angle + rand((this._spread*1000).toInteger())*1.0/1000 - this._spread / 2;

        particle.vx = this.speed * Math.cos(angle);
        particle.vy = this.speed * Math.sin(angle);
        particle.image = this._particleImages[rand(this._particleImages.length)];
        
        this._particles.push(particle);
        if (typeof this.particleCreated == #function)
            this.particleCreated.call(this, particle);
        return particle;
    }*/
}