// Represents one cell on battle area
class MineCell : GameControl
{
    const _STATE_MINE = -1;
    
    function init()
    {
        super.init();
        this.width = res.integers.cellWidth;
        this.height = res.integers.cellWidth;
        this.anchorX = this.width / 2;
        this.anchorY = this.height / 2;
        this.scene = false;

        //contains number of mines in neighbor cells or _state_MINE for mine
        this._state = 0;
        // _animate is true when explosion
        this._animate = false;
        // number of _frame in the animation
        this.frame = 0;
        // this.minesCounter = res.integers.mines;
        this._row = 0;
        this._columns = 0;
        // true/false if this cell is _uncovered (player can see mine or digit)
        this._uncovered = false;
        // call back function
        this.uncover = null;
        // true/false if cell contains flag
        this._mark = false;
        this.timer = 0;
        this._calculateTextDimensions();

    }

    // @region properties
    // uncover or cover cell
    property uncovered(v)
    {
        get {
            return this._uncovered;
        }
        set {
            return this._uncovered = v;
        }
    }

    property state(v)
    {
        get {
            return this._state;
        }
        set {
            return this._state = v;
        }
    }

    // uncover or cover cell
    property mark(v)
    {
        get {
            return this._mark;
        }
        set {
            return this._mark = v;
        }
    }

    property row(v)
    {
        set this._row = v;
        get return this._row;
    }

    property column(v)
    {
        set this._column = v;
        get return this._column;
    }
    // @endregion

    // @region public functions
    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);
        // do nothing if user press uncovered cell or game is paused
        if(this._uncovered || this.scene.paused)
            return;
    
        // start timer
        this._timer = new Timer(1, false);
        this._timer.onTick = function()
        {
            var self = this super;
            if(!self._mark) {
                self._mark = true;
                this super.scene.counter.count --;
            } else {
                self._mark = false;
                this super.scene.counter.count ++;
            }
            self._timer = null;
        }
        this._timer.start(res.integers.timeInterval);
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);
        // do nothing if user press uncovered cell or game is paused
        if(this._uncovered || this.scene.paused)
            return;
    
        // dispose timer
        if (this._timer != null) {
            this._timer.dispose();
            this._timer = null;
            // unmark or uncover cell
            if (this._mark) {
                this._mark = false;
                this.scene.counter.count ++;
            } else {
                this._uncovered = true;
                if(this._state == 0) {
                    // if _state is 0 we need to uncover larger area (all 0 in surounding cells). it manages uncover function
                    this.uncover(this.row, this.column);
                } else {
                    // if _state is _state_MINE we found mine
                    if(this._state == _STATE_MINE) {
                        // inform game scene that mine was uncovered
                        this.open(true);
                    } else
                        // inform game scene that cell without mine was uncovered
                        this.open(false);
                }
            }
        }
    }

    // draws the cell
    function draw(canvas)
    {
        canvas.save();
        canvas.translate(this.x, this.y);
        canvas.scale(0.95, 0.95);
    
        if (this._uncovered == false)
            if(this._mark)
                this._drawMarked(canvas);
            else
                this._drawCovered(canvas);
        else
            this._drawUncovered(canvas);
    
        canvas.restore();
    }
    // @endregion

    function _drawCovered(canvas)
    {
        canvas.drawRoundRect(this.width / -2, this.width / -2, this.width / 2, this.width / 2, this.width / 10, this.width / 10, res.paints.coveredCell);
    }

    function _drawMarked(canvas)
    {
        canvas.drawRoundRect(this.width / -2, this.width / -2, this.width / 2, this.width / 2, this.width / 10, this.width / 10, res.paints.markedCell);
    
        canvas.drawPath(res.vectors.flag, res.paints.flag);
    }

    function _drawUncovered(canvas)
    {
        // draw bacground
        if (this._state > 0)
            canvas.drawRoundRect(this.width / -2, this.width / -2, this.width / 2, this.width / 2, this.width / 10, this.width / 10, res.paints.coveredCell);
        else
            canvas.drawRoundRect(this.width / -2, this.width / -2, this.width / 2, this.width / 2, this.width / 10, this.width / 10, res.paints.uncoveredCell);
    
        // draw animation if the cell is animated
        if (this.frame > 0) {
            canvas.drawBitmapNine(res.images.explosion[this.frame], this.width / -2, this.width / -2, this.width / 2, this.width / 2);
            return;
        }
    
        // draw text or mine icon
        switch (this._state)
        {
            case _STATE_MINE:
                res.paints.text.color = 0xffffffff;
                canvas.drawPath(res.vectors.mine, res.paints.text);
                break;
            case 0:
                break;
            case 1:
                res.paints.text.color = 0xff7DFAFF;
                canvas.drawText("1", this.textDimensions[0].w / -2, this.textDimensions[0].h / 2, res.paints.text);
                break;
            case 2:
                res.paints.text.color = 0xff6EFF5B;
                canvas.drawText("2", this.textDimensions[1].w / -2, this.textDimensions[0].h / 2, res.paints.text);
                break;
            case 3:
                res.paints.text.color = 0xffFFC300;
                canvas.drawText("3", this.textDimensions[2].w / -2, this.textDimensions[0].h / 2, res.paints.text);
                break;
            default:
                res.paints.text.color = 0xffFFC300;
                canvas.drawText(this._state.toString(), this.textDimensions[3].w/ -2, this.textDimensions[0].h / 2, res.paints.text);
                break;
        }
    
    }

    function _calculateTextDimensions()
    {
        var (w, h) = res.paints.text.measureText("1");
        this.textDimensions = new Array();
        this.textDimensions[0] = {w : w, h : h};
        (w, h) = res.paints.text.measureText("2");
        this.textDimensions[1] = {w : w, h : h};
        (w, h) = res.paints.text.measureText("3");
        this.textDimensions[2] = {w : w, h : h};
        (w, h) = res.paints.text.measureText("4");
        this.textDimensions[3] = {w : w, h : h};
    }

    // start explosion
    function explode(delay = 0)
    {
        this.timer = new Timer(res.integers.explosionDuration / res.images.explosion.length, res.images.explosion.length);
        this.timer.onTick = function()
        {
            // increase frame number
            if (this super.frame < res.images.explosion.length-1) {
                this super._uncovered = true;
                this super.frame += 1;
            } else {
                // zero timer variable after last tiper repetition (after dimer dispose)
                this super.timer = 0;
            }
        }
        this.timer.start(delay);
    }

    function stopExplosion()
    {
        if (this.timer) {
            this.timer.dispose();
            this.timer = 0;
        }
    }
}