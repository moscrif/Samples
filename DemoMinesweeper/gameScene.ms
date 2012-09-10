class GameScene : Scene
{
    function init()
    {
        super.init();

        this.rows = res.integers.rows;
        this.columns = res.integers.rows;
        this.mines = res.integers.mines;
        this.opened = 0;

        this.counter = new MinesCounter({x : 3 * System.width / 4, y : System.height - res.integers.cellWidth * 10, z : 1})
        this.add(this.counter);
        this.timer = new TimerSprite({x : System.width / 4, y : System.height - res.integers.cellWidth * 10, z : 1})
        this.add(this.timer);
        this._menu = new Menu({scene : this, x : System.width / 2, y : res.integers.menuHeight / -4, z : 2, frameWidth : System.width,  width : System.width, height : res.integers.menuHeight})
        this.add(this._menu);

        this.minesList = new Array();   // array of positions of all mines
        this.table = new Array();
        this._paused = false;

        this._createTable();
        this._placeMines();
    }

    property paused(v)
    {
        get return this._paused;
        set this._paused = v;
    }

    function draw(canvas)
    {
        // draw background filled by gradient
        canvas.drawRect(0, 0, System.width, System.height, res.paints.background);
    
        //draw logo
        canvas.drawPath(res.vectors.logo, res.paints.logo);

        super.draw(canvas);
    }

    // stop animation
    function _stopExplosion()
    {
        for (var i = 0; i < this.mines; i++)
            this.table[this.minesList[i][0]][this.minesList[i][1]].stopExplosion();
    }
    // generate new position of mines
    function newGame()
    {
        if (this._menu.showed)
            this._menu.hide();
        this._stopExplosion();
        for (var i = 0; i<this.columns; i++) {
            for (var q = 0; q<this.rows; q++) {
                this.table[i][q].uncovered = false;
                this.table[i][q].mark = false;
                this.table[i][q].state = 0;
                this.table[i][q].frame = 0;
           }
        }
        // app.animate = false;
        this.opened = 0;
        this._placeMines();
        this.timer.reset();
        this.timer.start();
        this.paused = false;
        this.counter.count = this.mines;
    }

    // hide all mines. mines stay on same position
    function restart()
    {
        if (this._menu.showed)
            this._menu.hide();
        this._stopExplosion();
        for (var i = 0; i<this.columns; i++) {
            for (var q = 0; q<this.rows; q++) {
                this.table[i][q].uncovered = false;
                this.table[i][q].mark = false;
                this.table[i][q].frame = 0;
           }
        }
        this.opened = 0;
        this.timer.reset();
        this.timer.start();
        this.paused = false;
        this.counter.count = this.mines;
    }

    function _createTable()
    {
        var cellSide = res.integers.cellWidth;
        // left and top border of table
        var left = (System.width - 9*cellSide) / 2 + cellSide / 2;
        var top = System.height - this.rows*cellSide;
        // create cells
        for (var i = 0; i<this.columns; i++) {
            this.table[i] = new Array();
            for (var q = 0; q<this.rows; q++) {
                this.table[i][q] = new MineCell({
                    row     : i,
                    column  : q,
                    x       : left + i*cellSide,
                    y       : top + q*cellSide,
                });
                this.table[i][q].uncover = function(x,y) {this super._uncoverNull(x,y); };
                this.table[i][q].open = function(mine) { this super._open(mine); };
                this.table[i][q].scene = this;
                this.add(this.table[i][q]);
            }
        }
    }

    // deploy mines tu the table and also calculate all numbers
    function _placeMines()
    {
        var x,y;
        // calculate random positions of mines
        for(var i = 0; i<this.mines; i++) {
            do {
                // generate x and y position
                x = rand(this.columns - 1);
                y = rand(this.rows - 1);
                // if there is mine on generated position generate new position
            } while (this.table[x][y]._state == -1);
    
            this.table[x][y]._state = -1;
            this.minesList[i] = new Array();
            this.minesList[i][0] = x;
            this.minesList[i][1] = y
            this._addToNeighbours(x,y)
        }
    }

    // add one to all neighbours of mine
    function _addToNeighbours(x,y)
    {
        for (var i = x-1; i < x + 2; i++) {
             for (var q = y-1; q < y + 2; q++) {
                if (this._inTable(i,q) && !(y == q && x == i) && this.table[i][q]._state != -1)
                    this.table[i][q]._state += 1;;
             }
        }
    }

    // check if cell on position x, y exists in table (used in this._addToNeighbours)
    function _inTable(x, y)
    {
        if (x>-1 && x < this.columns && y>-1 && y < this.rows)
            return true;
        return false;
    }


    // uncover cell with no number with all null neighbours.
    function _uncoverNull(r, c)
    {
        this.table[r][c].uncovered = true;
        this._open(false);
    
        if (this.table[r][c]._state  == 0) {
            for (var i = r-1; i < r + 2; i++) {
                for (var q = c-1; q < c + 2; q++) {
                    if (this._inTable(i,q) && !this.table[i][q].uncovered && !this.table[i][q].mark)
                        this._uncoverNull(i, q);
                }
            }
        }
    }

    function _open(mine)
    {
        this.opened += 1;
        if (mine) {
            this._menu.show();
            this.timer.stop();
            this._menu.text = "OMG, commodore! We lost the whole fleet!";
            this._menu.time = this.timer.timeString;
            this._startExplosions();
            this.paused = true;
        } else
            // check if all cells without mines are opened
            if (this.opened == this.rows * this.columns - this.mines) {
                this._menu.show();
                this.timer.stop();
                this._menu.text = "Welldone commodore! The sea is our again ...";
                this._menu.time = this.timer.timeString;
                this.paused = true;
            }
    }

    function _startExplosions()
    {
        for (var i = 0; i < this.mines; i++) {
            this.table[this.minesList[i][0]][this.minesList[i][1]].explode(i*res.integers.explosionDelay);
        }
    }
}