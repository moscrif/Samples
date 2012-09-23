class SensorClass
{
    function this()
    {
        // check if senzor is available
        if (!Sensor.isAvailable(#acceleration))
            return false;
        
        // manage sensor
        this._sensor = new Sensor(#acceleration, 40);
        // setup handler for receiving data
        this._sensor.onDataReceived = function(sender, timestamp, params) {
            this super._calculateAngle(params);
        };
        // start receiving data
        this._sensor.start();

        this._angleX = false;
        this._angleY = false;
        this._gForce = 9.80665;
    }

    property angleX(v)
    {
        get return this._angleX;
    }

    property angleY(v)
    {
        get return this._angleY;
    }

    function _calculateAngle(params)
    {
        this._angleY = params[1];
        if (params[0] == 0.0)
            this._angleX = 0.0;
        else
            if (Math.abs(params[0]) < this._gForce)
                this._angleX = (((Math.asin(params[0] / this._gForce)) * 180.0/Math.PI)*100).toInteger()*1.0 / 100.0;
            else
                if (params[0] > 0)
                    this._angleX = 90.0;
                else
                    this._angleX = -90.0;
    
        if (params[1] == 0.0)
            this._angleY = 0.0
        else
            if (Math.abs(params[1]) < this._gForce)
                this._angleY = (((Math.asin(params[1] / this._gForce)) * 180.0/Math.PI)*100).toInteger()*1.0 / 100.0;
            else
                if (params[1] > 0)
                    this._angleY = 90.0;
                else
                    this._angleY = -90.0;
    }
}