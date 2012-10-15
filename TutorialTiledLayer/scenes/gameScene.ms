include "lib://game2d/scene.ms"
include "lib://game2d/tiledLayer.ms"

class GameScene : Scene
{
    function init()
    {
        super.init();
        // add sprites, layers, etc...

        this.layer = this._addTiledLayer();
        this.add(this.layer);

        this._textPaint = new Paint();
        this._textPaint.textSize = System.height / 20;
    }

        // overwritten
    function pointerPressed(x, y)
    {
        // call parents pointer pressed function
        super.pointerPressed(x, y);
        // save tap coordinates
        this._startX = x;
        this._startY = x;
        this._down = #start;
    }
    
    // overwritten
    function pointerDragged(x, y)
    {
        // call parents pointer dragged function
        super.pointerDragged(x, y);
        if (this._down == #drag) {
            // move layer
            this.layer.viewX += (this._startX - x);
            this.layer.viewY += (this._startY - y);
            // check bounds
            if (this.layer.viewX < 0)
                this.layer.viewX = 0;
            if (this.layer.viewY < 0)
                this.layer.viewY = 0;
            var leftSide = this.layer.width - System.width;
            if (this.layer.viewX > leftSide)
                this.layer.viewX = leftSide;
            var rightSide = this.layer.height - System.height;
            if (this.layer.viewY > rightSide)
                this.layer.viewY = rightSide;
        }
        // update coordinates
        this._startX = x;
        this._startY = y;
        if (this._down == #start)
            this._down = #drag;
    }
    
    // overwritten
    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);
        this._down = undefined;
    }

    function draw(canvas)
    {
        super.draw(canvas);

        canvas.drawText(String.printf("FPS: %2.f", System.avgFPS), 10, 80, this._textPaint);
    }

    function _addTiledLayer()
    {
        // get access to the source file for reading
        var file = Stream.openFile("app://tileMaps/exported.json", "r");
        // load file's data
        var data = parseData(file);
        // close file
        file.close();

        // create tiled layer
        var tiled = new TiledLayer({
            columns     : data["width"],
            rows        : data["height"],
            image       : GFX.tiles,
            tileWidth   : data["tilewidth"],
            tileHeight  : data["tileheight"],
            margin      : data["tilesets"][0]["margin"]
        });
    
        // fill cells
        var cells = data["layers"][0]["data"];
        for (var i = 0; i < cells.length; i++) {
            tiled.setCellDirect(i, cells[i] - 1);
        }

        // return created layer
        return tiled;
    }
}
