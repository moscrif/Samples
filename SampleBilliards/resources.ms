class Resources
{
    function this()
    {
        this._image = {
            table   : Bitmap.fromFile("app://gfx/table.png"),
            hole    : Bitmap.fromFile("app://gfx/hole.png"),
            cue     : Bitmap.fromFile("app://gfx/cue.png"),
            close   : Bitmap.fromFile("app://gfx/ico-close.png"),
            refresh : Bitmap.fromFile("app://gfx/ico-refresh.png"),
        }

        this._number = {
            tableRatio      : 1.76,     // length / width
            barWidth        : System.width / 7,     // bar width
            tableGap        : System.width / 14,
            mantinel        : 35,
            holeRadius      : 38,
            ballRadius      : 20,
            ballX           : 6*System.width / 10,
            ballY           : System.height / 2,
            lineLength      : System.width / 3,
            tableDamping    : 0.8,
            minSpeed        : 0.01,
            maxForce        : 100.0,
            hideAnimDuration: 1500,
        }
        // calculate other numbers
        this._number.tableWidth = System.width - this.number.barWidth - this.number.tableGap;
        this._number.tableHeight = (1.0*this._number.tableWidth / this.number.tableRatio).toInteger();
        if (this._number.tableHeight > System.height - 2*this.number.tableGap) {
            this._number.tableHeight = System.height - 2*this.number.tableGap;
            this._number.tableWidth = (1.0*this._number.tableHeight * this.number.tableRatio).toInteger();
        }
        this._number.mantinel = this._number.tableHeight / 15;
        this._number.ballRadius = this._number.mantinel/2;
        this._number.holeRadius = 9*this._number.mantinel / 10;

        var tableCentre = this._number.tableGap + (System.width - this._number.barWidth - this._number.tableGap) / 2;
        this._number.tableLeft = tableCentre - this._number.tableWidth / 2;
        this._number.tableTop = System.height / 2 - this._number.tableHeight / 2;

        this._paint = {
            hole        : this._createTablePaint(),
            line        : this._createLinePaint(),
            textPaint   : this._createTextPaint(),
        }
        this.ballColor = [
            0xFFFFD800, 0xFF008CFF, 0xFFFF0000, 0xFF0013A3, 0xff000000, 0xFFFF893A, 0xFF267F00, 0xFFC40000, 0xFFFFD800, 0xFF008CFF, 0xFFFF0000, 0xFF0013A3, 0xFFFF893A, 0xFF267F00, 0xFFC40000,
        ]
        this.ballType = [
            #full, #half, #full, #full, #full, #half, #half, #full, #half, #full, #half, #half, #full, #full, #half,
        ]
    }

    property number(v)
    {
        get return this._number;
    }

    property image(v)
    {
        get return this._image;
    }

    property paint(v)
    {
        get return this._paint;
    }

    function _createTextPaint()
    {
        var p = new Paint();
        p.textSize = System.height / 35;

        var (w, h) = p.measureText("force up");
        this._number.forceUpTextWidth = w;
        (w, h) = p.measureText("force down");
        this._number.forceDownTextWidth = w;
        return p;
    }

    function _createLinePaint()
    {
        var p = new Paint();

        // create paint object
        var pts = {
            start :
            {
                x: 0,
                y : 0,
            },
            end :
            {
                x: 0,
                y : this.number.lineLength,
            }
        }
        var clrs = new Array(0xFF222222, 0x00000000);
        var pos = new Array(0.2, 1.0);
        p.shader = Shader.linear(pts, clrs, pos, 0);

        return p;
    }

    function _createTablePaint()
    {
        var p = new Paint();
        p.color = 0xff00ff00;

        return p;
    }
}