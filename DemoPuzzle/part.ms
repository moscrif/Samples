include "lib://game2d/sprite.ms";

class Part : Sprite
{
    // @region Construction

    function init()
    {
        super.init();
        //Position where the image should be located
        this._locX = 0;
        this._locY = 0;
        //Relative position
        this._relX = 0;
        this._relY = 0;
        //Flag, which determines wheter picture is on the right place.
        this._isOnPlace = false;
    }

    // @endregion

    // @region Properties

    property x(v)
    {
        get return this._x;
        set this._x = v + this.relX;
    }

    property y(v)
    {
        get return this._y;
        set this._y = v + this.relY;
    }

    property locX(v)
    {
        get return this._locX;
        set this._locX = v;
    }

    property locY(v)
    {
        get return this._locY;
        set this._locY = v;
    }

    property relX(v)
    {
        get return this._relX;
        set this._relX = v;
    }

    property relY(v)
    {
        get return this._relY;
        set this._relY = v;
    }

    property isOnPlace(v)
    {
        get return this._isOnPlace;
        set this._isOnPlace = v;
    }

    // @endregion

    /**
    Check distance from location where part should be and if is too close move him to right place.
    @param sender Object
    */
    function push(sender)
    {
        //Calculate the distance from the position
        //where the image should be located
        // |draw, loc|
        var sizeX = Math.pow((this.locX + this.width/2) - this.x,2);
        var sizeY = Math.pow((this.locY + this.height/2) - this.y,2);
        var size  = Math.sqrt(sizeX + sizeY);

        //If the distance is smaller than constant
        if (size < System.width / 38) {
            //Set picture location on the right position.
            this.x = this.locX + this.width/2 - this.relX;
            this.y = this.locY + this.height/2 - this.relY;
            //If picture wasnt on the right position.
            if (!this.isOnPlace) {
                //Increment variable, which remember count of picture, which are on right position.
                sender._onPlace++;
                this.isOnPlace = true;
            }
        //Picture was on right position, but he is not anymore.
        } else if (this.isOnPlace) {
            sender._onPlace--;
            this.isOnPlace = false;
        }
    }
}