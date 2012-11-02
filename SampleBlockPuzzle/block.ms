class Block
{
    function this()
    {
        //@region blocks definition
        this._blocks = [
            // @region first block
            [
                // first state
                [
                    // first row
                    [1, 1],
                    // second row
                    [1, 1],
                ]
            ],
            // @endregion
            // @region second block
            [
                // first state
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
                // second state
                [
                    // first row
                    [1, 1, 1, 1],
                ],
            ],
            // @endregion
            // @region third block
            [
                // first state
                [
                    // first row
                    [1, 1, 1],
                    // second row
                    [1, 0, 0],
                ],
                // second state
                [
                    // first row
                    [1, 0],
                    // second row
                    [1, 0],
                    // third row
                    [1, 1],
                ],
                // third state
                [
                    // first row
                    [0, 0, 1],
                    // second row
                    [1, 1, 1],
                ],
                // fourth state
                [
                    // first row
                    [1, 1],
                    // second row
                    [0, 1],
                    // third row
                    [0, 1],
                ],
            ],
            // @endregion
            // @region fourth block
            [
                // first state
                [
                    // first row
                    [0, 1, 0],
                    // second row
                    [1, 1, 1],
                ],
                // second state
                [
                    // first row
                    [1, 0],
                    // second row
                    [1, 1],
                    // third row
                    [1, 0],
                ],
                // third state
                [
                    // first row
                    [1, 1, 1],
                    // second row
                    [0, 1, 0],
                ],
                // fourth state
                [
                    // first row
                    [0, 1],
                    // second row
                    [1, 1],
                    // third row
                    [0, 1],
                ],
            ],
            // @endregion
            // @region fifth block
            [
                // first state
                [
                    // first row
                    [0, 1, 1],
                    // second row
                    [1, 1, 0],
                ],
                // second state
                [
                    // first row
                    [1, 0],
                    // second row
                    [1, 1],
                    // third row
                    [0, 1],
                ],
            ],
            // @endregion
            // @region sixth block
            [
                // first state
                [
                    // first row
                    [1, 1, 0],
                    // second row
                    [0, 1, 1],
                ],
                // second state
                [
                    // first row
                    [0, 1],
                    // second row
                    [1, 1],
                    // third row
                    [1, 0],
                ],
            ],
            // @endregion
            // @region seventh block
            [
                // first state
                [
                    // first row
                    [1, 1, 1],
                    // second row
                    [0, 0, 1],
                ],
                // second state
                [
                    // first row
                    [1, 1],
                    // second row
                    [1, 0],
                    // third row
                    [1, 0],
                ],
                // third state
                [
                    // first row
                    [1, 0, 0],
                    // second row
                    [1, 1, 1],
                ],
                // fourth state
                [
                    // first row
                    [0, 1],
                    // second row
                    [0, 1],
                    // third row
                    [1, 1],
                ],
            ],
        ];
        // @endregion
        // generate random block
        this._block = rand(7);
        // first state
        this._state = 0;
        this._newState = 0;
        // random block state
        this.color = rand(5) + 1;
        this.top = 0;
        this.left = 8 - this._blocks[this._block][0][0].length / 2;
        this._newLeft = -1;
        // parents playground
        this._playground = null;
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
        // set all tiles of curently moving block to the frst frame (no color)
        for (var i = 0; i < this._blocks[this._block][this._state].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._state][i].length; q++) {
                if (this._blocks[this._block][this._state][i][q])
                    this.playground.setCell(this.left + q, this.top + i, 0);
            }
    
        // update block state
        this._state = this._newState;
        if (this._newLeft != -1)
            this.left = this._newLeft;
    
        this._newLeft = -1;
    
        if (step)
            this.top += 1;
    
        // set all tiles to the new of block state
        for (var i = 0; i < this._blocks[this._block][this._state].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._state][i].length; q++) {
                if (this._blocks[this._block][this._state][i][q])
                    this.playground.setCell(this.left + q, this.top + i, this.color);
    
            }
        return true;
    }

    function canChangeState()
    {
        var gap = this._newLeft - this.left;
    
        for (var i = 0; i < this._blocks[this._block][this._newState].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._newState][i].length; q++) {
                // is is a sqare on the place
                if (this._blocks[this._block][this._newState][i][q] == 1) {
                    // is not there any other block on under the new state oxfmmn.lf
    
                    if (this.playground.getCell(this._newLeft + q, this.top + i) != 0)
                        // if there was an old state over it
                        if (i < this._blocks[this._block][this._state].length && (q + gap) > -1 && (q + gap) < this._blocks[this._block][this._state][i].length) {
                            if (!(this._blocks[this._block][this._state][i][q + gap]))
                                return false;
                        } else  // otherwise it can be only from other block
                            return false;
                }
            }
        return true;
    }

    function changeState()
    {
        // current left position and state (rotation)
        var l = this._newLeft;
        var p = this._newState;
        // move to next state
        if (this._state < this._blocks[this._block].length - 1)
            this._newState = this._state + 1;
        else
            this._newState = 0;
        // calculate new left position
        this._newLeft = this.left + (this._blocks[this._block][this._state][0].length - this._blocks[this._block][this._newState][0].length)/2

        var width = this._blocks[this._block][this._newState][0].length;
        if (this._newLeft < 0)
            this._newLeft = 0;
        else if (this._newLeft > this.playground.columns - width)
            this._newLeft = this.playground.columns - width;

        if (!this.canChangeState()) {
            this._newState = p;
            this._newLeft = l;
        } else
            this.redrawBlock(false);
    }

    function canStep()
    {
        var top = this.top;
        // if the block is on the bottom of the screen
        if (top + this._blocks[this._block][this._state].length > this.playground.rows - 1)
            return false;
    
        // move one row down
        top = this.top + 1;
    
        // number of rows in the block map
        var height = this._blocks[this._block][this._state].length;
    
        // go throw all rows in the map
        for (var i = 0; i < height; i++)
            // go throw all columns in tbe block map
            for (var q = 0; q < this._blocks[this._block][this._state][i].length; q++) {
                // if there is on in the map and is no free space on the playground
                if (this._blocks[this._block][this._state][i][q] == 1 && this.playground.getCell(this.left + q, top+i) != 0) {
                    if (i < height - 1) {
                        // and there is some other block (no curently moved)
                        if (this._blocks[this._block][this._state][i + 1][q] != 1)
                            // stop moving
                            return false;
                    } else
                        return false;
                }
            }
        return true;
    }

    function canMove(dir)
    {
        var width = this._blocks[this._block][this._state][0].length;
        if (dir == #left) {
            if (this.left < 1)
                return false;
            for (var q = 0; q < this._blocks[this._block][this._state].length; q++) {
                if (this._blocks[this._block][this._state][q][0] == 1 && this.playground.getCell(this.left-1, this.top+q) != 0)
                    return false;
            }
        } else {
            if (this.left > this._playground.columns - width)
                return false;
            for (var q = 0; q < this._blocks[this._block][this._state].length; q++) {
                if (this._blocks[this._block][this._state][q][width-1] == 1 && this.playground.getCell(this.left+width, this.top+q) != 0)
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
        var columns = this._blocks[this._block][this._state][0].length;

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