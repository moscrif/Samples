class AI : Player
{
    function init()
    {
        super.init();

        this.image = Bitmap.fromFile("app://enemy.png");
    }

    function canMove(x, y)
    {

        x += this.tiled.viewX;
        y += this.tiled.viewY;

        var index = this.tiled.getCell(x/this.tiled.tileWidth, (y + 15)/this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index!=2) {
            this.direction = #up;
            return false;
        }

        index = this.tiled.getCell(x/this.tiled.tileWidth, (y - 15)/this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index!=2) {
            this.direction = #down;
            return false;
        }

        index = this.tiled.getCell((x + 15)/this.tiled.tileWidth, y /this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index!=2) {
            this.direction = #left;
            return false;
        }

        index = this.tiled.getCell((x - 15) /this.tiled.tileWidth, y/this.tiled.tileHeight);
        // if index of image is wall, character cant move
        if (index!=2) {
            this.direction = #right;
            return false;
        }
        return true;
    }
    // this event is called when character moved
    function onMove(x, y)
    {
        var dx = x - this.level._player.x;
        var dy = y - this.level._player.y;
        var distance = Math.sqrt(dx*dx + dy*dy);
        if (distance < 50) {
            this.level.add(new Message({text: "A shark ate you!!!", scene : this.level}));
        }
    }
}