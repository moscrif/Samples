class AI : Player
{
    function this()
    {
        super();

        this.index = 40;
    }

    property direction(v)
    {
        set {
            // set draw sequence and move constant on the base direction property
            switch(v)
            {
                case #down:     this.index = 40;    this.moveX = 0;     this.moveY = 1;  break;
                case #left:     this.index = 42;    this.moveX = -1;    this.moveY = 0;  break;
                case #right:    this.index = 43;    this.moveX = 1;     this.moveY = 0;  break;
                case #up:       this.index = 41;    this.moveX = 0;     this.moveY = -1; break;
                case #stop:     this.moveX = 0;     this.moveY = 0;     break;
            }
        }
    }

    function canMove(x, y)
    {
        console<<this.tiled<<" tiled\n";
        var index = this.tiled.getCell(x, y);
        // if index of image is wall, character cant move
        if (index==2)
            return true;

        return false;
    }
}