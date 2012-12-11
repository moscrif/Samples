include "lib://game2d/particle/lineEmitter.ms"

class FireEmitter2 : LineEmitter
{
    function init()
    {
        super.init();
    }

    function _timeStep()
    {
        var particle;
        // go throw all existing particles
        for (particle in this._particles) {
            // check if it is no need to remove the particle
            if (this._particleLife != -1 && particle._age > 2*this._particleLife / 4 && (rand(10) > 6 || particle._age > this._particleLife)) {
                    this._particles.removeByValue(particle);
            } else {
                // move particle
                if (this._fields != null && this._fields.length > 0)
                    particle.move(1000 / this._stepsPerSeconds, this._fields);
                else
                    particle.move(1000 / this._stepsPerSeconds);
            }
        }
    
        // add new particles
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
}