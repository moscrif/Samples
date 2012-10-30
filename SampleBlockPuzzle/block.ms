class Block
{
    function this()
    {
        //@region blocks definition
        this._blocks = [
            // first block
            [
                // first position
                [
                    // first row
                    [1, 1],
                    // second row
                    [1, 1],
                ]
            ],
            // second block
            [
                // first position
                [
                    // first row
                    [1],
                    // second row
                    [1],
                    // third row
                    [1],
                    // fourth row
                    [1],
                ],
                // second position
                [
                    // first row
                    [1, 1, 1, 1],
                ],
            ],
        ];
        // @endregion
        this._block = 1;
        this._position = 0;
        this._newPosition = 0;

        this.top = 0;
        this._playground = null;
        this.color = rand(5) + 1;
        this.left = 0;//8 - this._blocks[this._block][0][0].length / 2;
        this._newLeft = -1;


    }

    function step()
    {
        if (this.playground == null)
            return;

        return this.redrawBlock();
    }

    function redrawBlock(step = true)
    {
        if (!this.canStep())
            return false;

        for (var i = 0; i < this._blocks[this._block][this._position].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._position][i].length; q++) {
                if (this._blocks[this._block][this._position][i][q])
                    this.playground.setCell(this.left + q, this.top + i, 0);
            }

        this._position = this._newPosition;
        if (this._newLeft != -1)
            this.left = this._newLeft;

        this._newLeft = -1;

        if (step)
            this.top += 1;

        for (var i = 0; i < this._blocks[this._block][this._position].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._position][i].length; q++) {
                if (this._blocks[this._block][this._position][i][q])
                    this.playground.setCell(this.left + q, this.top + i, this.color);

            }
        return true;
    }

    function changePosition()
    {
        if (this._position < this._blocks[this._block].length - 1)
            this._newPosition = this._position + 1;
        else
            this._newPosition = 0;
        this._newLeft = this.left + (this._blocks[this._block][this._position][0].length - this._blocks[this._block][this._newPosition][0].length)/2
        this.redrawBlock(false);
    }

    function canStep()
    {
        var top = this.top + this._blocks[this._block][this._position].length;
        if (top > this.playground.rows - 1)
            return false;

        top = this.top + 1;

        var height = this._blocks[this._block][this._position].length-1;

        for (var q = 0; q < this._blocks[this._block][this._position][height].length; q++) {
            if (this._blocks[this._block][this._position][height][q] == 1 && this.playground.getCell(this.left + q, top+height) != 0)
                return false;
        }
        return true;
    }

    function canMove(dir)
    {
        var width = this._blocks[this._block][this._position][0].length;
        if (dir == #left) {
            console<<"check L \n";
            if (this.left < 1)
                return false;
            for (var q = 0; q < this._blocks[this._block][this._position].length; q++) {
                if (this._blocks[this._block][this._position][q][0] == 1 && this.playground.getCell(this.left-1, this.top+q) != 0)
                    return false;
            }
        } else {
            if (this.left > this._playground.columns - width)
                return false;
            for (var q = 0; q < this._blocks[this._block][this._position].length; q++) {
                if (this._blocks[this._block][this._position][q][width-1] == 1 && this.playground.getCell(this.left+width, this.top+q) != 0)
                    return false;
            }
        }
        return true;
    }

    function move(gap)
    {
        if (gap < 0) {
            if(!this.canMove(#left))
                return false;
        } else {
            if(!this.canMove(#right))
                return false;
        }

        this._newLeft = this.left + gap;
        var columns = this._blocks[this._block][this._position][0].length;

        if (this._newLeft < 1)
            this._newLeft = 0;
        else if (this._newLeft > this.playground.columns - columns)
            this._newLeft = this.playground.columns - columns;

        this.redrawBlock(false);
    }

    property playground(v)
    {
        get return this._playground;
        set this._playground = v;
    }
}