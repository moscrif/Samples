class Player
{
    function this()
    {
        this._row = 0;
        this._column = 0;
        this.moveX = 0;
        this.moveY = 0;

        // create timer
        this._createTimer();
        this.tiled = null;
        this.level = null;

        this.index = 30;
    }

    property row(v)
    {
        get return this._row;
        set {
            this._row = v;
            if (this.canMove(this.column, this.row))
                this.move(this.column, this.row);
        }
    }

    property column(v)
    {
        get return this._column;
        set {
            this._column = v;
            if (this.canMove(this.column, this.row))
                this.move(this.column, this.row);
        }
    }

    property direction(v)
    {
        set {
            // set draw sequence and move constant on the base direction property
            switch(v)
            {
                case #down:     this.index = 30;    this.moveX = 0;     this.moveY = 1;  break;
                case #left:     this.index = 32;    this.moveX = -1;    this.moveY = 0;  break;
                case #right:    this.index = 33;    this.moveX = 1;     this.moveY = 0;  break;
                case #up:       this.index = 31;    this.moveX = 0;     this.moveY = -1; break;
                case #stop:     this.moveX = 0;     this.moveY = 0;     break;
            }
        }
    }

    function _createTimer()
    {
        // create timer (interval, repeat)
        this.timer = new Timer(100, true);
        this.timer.onTick = function(sender)
        {
            var self = this super;
            // check if character is moving
            // check if on next position is some barrier
            if (self.canMove(self.column+self.moveX, self.row+self.moveY)) {
                // fire event onMove
                self.move(self.column+self.moveX, self.row+self.moveY);
            }
        }
        // start timer with 0 ms delay
        this.timer.start(0);
    }

    function canMove(x, y)
    {
        var index = this.tiled.getCell(x, y);
        // if index of image is wall, character cant move
        if (index==0 || index == 6)
            return false;

        return true;
    }

    function move(x, y)
    {
        var index = this.tiled.getCell(x, y);

        this.tiled.setCellDirect(this.row*this.tiled.columns + this.column, 2);
        this.tiled.setCellDirect(y*this.tiled.columns + x, this.index);

        this._row = y;
        this._column = x;

        // compute right and bottom boundaries
        var rightSide = this.tiled.width - System.width;
        var bottomSide = this.tiled.height - System.height;
        var oldViewX = this.tiled.viewX;
        var oldViewY = this.tiled.viewY;
        // set tiled view
        this.tiled.viewX = x*this.tiled.tileWidth - System.width/2;
        this.tiled.viewY = y*this.tiled.tileHeight - System.height/2;
        // check boundaries
        this.tiled.viewX = Integer.max(this.tiled.viewX, 0);
        this.tiled.viewY = Integer.max(this.tiled.viewY, 0);
        this.tiled.viewX = Integer.min(this.tiled.viewX, rightSide);
        this.tiled.viewY = Integer.min(this.tiled.viewY, bottomSide);

        switch (index) {
            case 7:
                this.level.add(new Message({text: "A shark ate you!!!", scene : this.level}));
                break;
            case 25:
            case 26:
            case 27:
            case 28:
                this.level.add(new Message({text: "An enemy ate you!!!", scene : this.level}));
                break;
            case 9:
                this.level.nextLevel();
                break;
            case 10:
            case 11:
            case 12:
            case 13:
                this.level.score += 10;
                break;
            case 14:
            case 15:
            case 16:
                this.level.score += 15;
                break;
            case 17:
            case 18:
            case 19:
            case 20:
                this.level.score += 20;
                break;
        }
    }
}