class AI : Player
{
    function this()
    {
        super();

        this.index = 25;
        this._direction = 0;
    }

    function _createTimer()
    {
        // create timer (interval, repeat)
        this.timer = new Timer(200, true);
        this.timer.onTick = function(sender)
        {
            var self = this super;
            // check if character is moving
            // check if on next position is some barrier
            if (self.canMove(self.column+self.moveX, self.row+self.moveY)) {
                // fire event onMove
                self.move(self.column+self.moveX, self.row+self.moveY);
            } else {
                if (this super.direction == #up)
                    this super.direction = #down;
                else if (this super.direction == #down)
                    this super.direction = #up;
                else if (this super.direction == #left)
                    this super.direction = #right;
                else if (this super.direction == #right)
                    this super.direction = #left;
            }
        }
        // start timer with 0 ms delay
        this.timer.start(0);
    }


    property direction(v)
    {
        get return this._direction;
        set {
            this._direction = v;
            // set draw sequence and move constant on the base direction property
            switch(v)
            {
                case #down:     this.index = 25;    this.moveX = 0;     this.moveY = 1;  break;
                case #left:     this.index = 27;    this.moveX = -1;    this.moveY = 0;  break;
                case #right:    this.index = 28;    this.moveX = 1;     this.moveY = 0;  break;
                case #up:       this.index = 26;    this.moveX = 0;     this.moveY = -1; break;
                case #stop:     this.moveX = 0;     this.moveY = 0;     break;
            }

       }
    }

    function canMove(x, y)
    {
        var index = this.tiled.getCell(x, y);
        // if index of image is wall, character cant move
        if (index==2 || index == 30 || index == 31 || index == 32 || index == 33)
            return true;

        return false;
    }

    function move(x, y)
    {
        var index = this.tiled.getCell(x, y);

        this.tiled.setCellDirect(this.row*this.tiled.columns + this.column, 2);
        this.tiled.setCellDirect(y*this.tiled.columns + x, this.index);

        this._row = y;
        this._column = x;

        switch (index) {
            case 30:
            case 31:
            case 32:
            case 33:
                this.level.add(new Message({text: "An enemy ate you!!!", scene : this.level}));
                game.paused = true;
                break;
        }
    }
}