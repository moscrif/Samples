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
        this._block = 1;//rand(2);
        this._position = 0;
        this._newPosition = 0;

        this.top = 0;
        this._playground = null;
        this.color = rand(5) + 1;
        this.left = 8 - this._blocks[this._block][0][0].length / 2;
        this._newLeft = false;
    }

    function step()
    {
        if (this.playground == null)
            return;

        this.redrawBlock();
    }

    function redrawBlock()
    {
        for (var i = 0; i < this._blocks[this._block][this._position].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._position][i].length; q++) {
                if (this._blocks[this._block][this._position][i][q])
                    this.playground.setCell(this.left + q, this.top + i, 0);
            }

        this._position = this._newPosition;
        if (this._newLeft != false)
            this.left = this._newLeft;

        this._newLeft = false;

        this.top += 1;

        for (var i = 0; i < this._blocks[this._block][this._position].length; i++)
            for (var q = 0; q < this._blocks[this._block][this._position][i].length; q++) {
                if (this._blocks[this._block][this._position][i][q])
                    this.playground.setCell(this.left + q, this.top + i, this.color);
                    console<<"set cell\n";
            }
    }

    function changePosition()
    {
        if (this._position < this._blocks[this._block].length - 1)
            this._newPosition = this._position + 1;
        else
            this._newPosition = 0;
        this._newLeft = this.left + (this._blocks[this._block][this._position][0].length - this._blocks[this._block][this._newPosition][0].length)/2
    }

    property playground(v)
    {
        get return this._playground;
        set {
            console<<"set playground "<<v<<"\n";
            this._playground = v;
        }
    }
}