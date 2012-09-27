class Player : Sprite
{
    function init()
    {
        super.init();
        // load image
        this.image = Bitmap.fromFile("app://player.png");
        // size of one frame
        this.frameWidth = 40;
        this.frameHeight = 40;
        // move vector
        this.moveX = 0;
        this.moveY = 0;
        // create timer
        this._createTimer();
        this.tiled = null;
        this.level = null;
    }

    property direction(v)
    {
        set {
            // set draw sequence and move constant on the base direction property
            switch(v)
            {
                case #down:     this.sequence = [0];    this.moveX = 0;     this.moveY = 4;  break;
                case #left:     this.sequence = [1];    this.moveX = -4;    this.moveY = 0;  break;
                case #right:    this.sequence = [2];    this.moveX = 4;     this.moveY = 0;  break;
                case #up:       this.sequence = [3];  this.moveX = 0;     this.moveY = -4; break;
                case #stop:                                 this.moveX = 0;     this.moveY = 0;  break;
            }
        }
    }

    function _createTimer()
    {
        // create timer (interval, repeat)
        var timer = new Timer(10, true);
        timer.onTick = function(sender)
        {
            var self = this super;
            // check if character is moving
            if (self.moveX || self.moveY)
                self.nextFrame();
            // check if on next position is some barrier
            if (self.canMove(self.x+self.moveX, self.y+self.moveY)) {
                self.x += self.moveX;
                self.y += self.moveY;
                // fire event onMove
                self.onMove(self.x, self.y);
            }
        }
        // start timer with 0 ms delay
        timer.start(0);
    }

   function canMove(x, y)
    {

        x += this.tiled.viewX;
        y += this.tiled.viewY;

        var index = this.tiled.getCell(x/this.tiled.tileWidth, (y + 15)/this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index==0 || index == 6)
            return false;

        index = this.tiled.getCell(x/this.tiled.tileWidth, (y - 15)/this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index==0 || index == 6)
            return false;

        index = this.tiled.getCell((x + 15)/this.tiled.tileWidth, y /this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index==0 || index == 6)
            return false;

        index = this.tiled.getCell((x - 15) /this.tiled.tileWidth, y/this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index==0 || index == 6)
            return false;
        return true;
    }
    // this event is called when character moved
    function onMove(x, y)
    {
        x += this.tiled.viewX;
        y += this.tiled.viewY;

        var column = x/this.tiled.tileWidth;
        var row = y/this.tiled.tileHeight;
        var index = this.tiled.getCell(x/this.tiled.tileWidth, y/this.tiled.tileHeight);
        switch (index) {
            case 7:
                System.messageBox("A shark ate you!!! ");
                game.quit();
                return;
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
        // compute right and bottom boundaries
        var rightSide = this.tiled.width - System.width;
        var bottomSide = this.tiled.height - System.height;
        var oldViewX = this.tiled.viewX;
        var oldViewY = this.tiled.viewY;
        // set tiled view
        this.tiled.viewX = x - System.width/2;
        this.tiled.viewY = y - System.height/2;
        // check boundaries
        this.tiled.viewX = Integer.max(this.tiled.viewX, 0);
        this.tiled.viewY = Integer.max(this.tiled.viewY, 0);
        this.tiled.viewX = Integer.min(this.tiled.viewX, rightSide);
        this.tiled.viewY = Integer.min(this.tiled.viewY, bottomSide);

        this.x -= this.tiled.viewX - oldViewX;
        this.y -= this.tiled.viewY - oldViewY;

        for (var i in this.level.enemies) {
            i.x -= this.tiled.viewX - oldViewX;
            i.y -= this.tiled.viewY - oldViewY;
        }

        this.tiled.setCellDirect(row*this.tiled.columns + column, 2);
    }
}