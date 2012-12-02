include "lib://game2d/particle/lineEmitter.ms"

class FireEmitter : LineEmitter
{
    function init()
    {
        super.init();

        this._particleImages = [GFX.flame1, GFX.flame2, GFX.flame3, GFX.flame4, GFX.flame5];
    }

    property width(v)
    {
        get return this._width;
        set {
            assert v instanceof Integer;
            this._width = v;
        }
    }

    function _addParticle(options = null)
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
    }
}