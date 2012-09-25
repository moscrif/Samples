class GameScene : PhysicsScene
{
    function init()
    {
        super.init();

        // create physics world
        this.world = new b2World(0.0, -9.8, true, false);
        this.world.setContinuousPhysics(false);
        //this.debugDraw = true;
        this.width = 2*System.width;
        this._translateX = 0;
        this._translateY = 0;
        this._x = 0;
        this._playerPosition = System.height / 2;
        this._speedPosition = System.height / 2;

        this._bike = new Bike();
        this._bike.create(this, System.width / 2, 6 * System.height / 10);

        this._createGround();
        //this.debugDraw = true;

        this.menu = new Menu({
            width       : System.width,
            height      : System.height,
            z : 3,
            onRefresh   : function()
            {
                this super.refresh();
            }
        });
        this.add(this.menu);

        this._createPaint();
    }

    // reaction to onproces event (repeates about every 25 miliseconds)
    function process()
    {
       var (x, y) = this._bike.getPosition();

        if (true) {
            this._translateX = -1*((x) - (4*System.width / 10));
            this.menu.translateX = this._translateX;
        }
        if (y < 2*System.height / 10) {
            this._translateY = -1*(y - 2*System.height / 10);
            this.menu.translateY = this._translateY;
        }
        if (y > 8*System.height / 10) {
            this._translateY = 1*(y - 8*System.height / 10);
            this.menu.translateY = this._translateY;
        }
        // create step in physics world
        this.step(1.0/40.0);
    }

    function draw(canvas)
    {
        canvas.drawRect(0, 0, System.width, System.height, this._bg);
        canvas.save();
        canvas.translate(this._translateX, this._translateY);

        super.draw(canvas);
        canvas.restore();
        // speed
        canvas.drawText("speed up", System.width / 15 - this._speedUpWidth / 2, System.height/2 - 165, this._textPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 - 143, 15, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 - 106, 12, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 - 73, 11, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 - 44, 8, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 - 20, 6, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2, 4, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 + 20, 6, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 + 44, 8, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 + 73, 11, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 + 106, 12, this._speedPaint);
        canvas.drawCircle(System.width / 15, System.height / 2 + 143, 15, this._speedPaint);
        canvas.drawText("speed down", System.width / 15 - this._speedDownWidth / 2, System.height/2 + 175, this._textPaint);
        // angle
        canvas.drawText("front up", System.width - System.width / 15 - this._speedFrontUp / 2, System.height/2 - 165, this._textPaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 - 143, 15, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 - 106, 12, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 - 73, 11, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 - 44, 8, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 - 20, 6, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2, 4, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 + 20, 6, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 + 44, 8, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 + 73, 11, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 + 106, 12, this._anglePaint);
        canvas.drawCircle(System.width - System.width / 15, System.height / 2 + 143, 15, this._anglePaint);
        canvas.drawText("front down", System.width - System.width / 15 - this._speedFrontDown / 2, System.height/2 +175, this._textPaint);
    }

    function pointerDragged (x, y, pointer)
    {
        super.pointerDragged(x, y);

        var maxSpeed = 33;
        var maxPlayer = 1.4 * this._bike.getMass();
        if (y < System.height / 2 - 150)
            y = System.height / 2 - 150;
        else if (y > System.height / 2 + 150)
            y = System.height / 2 + 150;

        if (x > 3*System.width / 4) {
            this._bike.player = (System.height / 2.0 - y) / 150 * maxPlayer;
            this._anglePaint.shader = this._createAngleShader(y);
        } else if (x < System.width / 4){
            this._bike.speed = -1*(System.height / 2.0 - y) / 150 * maxSpeed;
            this._speedPaint.shader = this._createSpeedShader(y);
        }
    }

    function _createSpeedShader(y)
    {
        var pts = {
            start :
            { 
                x: System.width / 2,
                y : y - 140,
            }, 
            end :
            { 
                x: System.width / 2,
                y : y + 140,
            }
        }
        var clrs = new Array(0x00000000, 0xff9F0000, 0x00000000);
        var pos = new Array(0.0, 0.5, 1.0);
        return Shader.linear(pts, clrs, pos, 0);
    };

    function _createAngleShader(y)
    {
        var pts = {
            start :
            { 
                x: System.width / 2,
                y : y - 140,
            }, 
            end :
            { 
                x: System.width / 2,
                y : y + 140,
            }
        }
        var clrs = new Array(0x00000000, 0xff267F00, 0x00000000);
        var pos = new Array(0.0, 0.5, 1.0);
        return Shader.linear(pts, clrs, pos, 0);
    };

    function _createGround()
    {
        var width = 100;
        var ground = Bitmap.fromFile("app://ground.png");
        for (var i = 0; i < width; i++)
            this.addPolygonBody(ground, #static, 0.0,0.9, 0.0, ground.width, ground.height).setPosition(ground.width/2 + i*ground.width, System.height - ground.height / 2 );

        var leftStop = this.addPolygonBody(Bitmap.fromFile("app://ground.png"), #static, 0.0, 0.0, 0.0, System.height, 1);
        leftStop.angle = Math.PI / 2;
        leftStop.setPosition(0, System.height / 2);

        var rightStop = this.addPolygonBody(Bitmap.fromFile("app://ground.png"), #static, 0.0, 0.0, 0.0, System.height, 1);
        rightStop.angle = Math.PI / 2;
        rightStop.setPosition(width*ground.width, System.height / 2);

        var rect = Bitmap.fromFile("app://rect.png");
        var scale = System.height / 400.0;
        var body;
        for (var i = 0; i < 80 + rand(20); i++) {
            body = this.addPolygonBody(rect, #dynamic, 1.0, 1.0, 0.0, rect.width * scale, rect.height * scale);
            body.scale = scale;
            body.setPosition(rand(width*ground.width), System.height - 55);
        }
        var ramp = Bitmap.fromFile("app://ramp.png");
        body = this.addPolygonBody(ramp, #static, 1.0, 1.0, 0.0, ramp.width, ramp.height);
        body.angle = Math.PI / 7;
        body.setPosition(width*ground.width / 4, System.height + ramp.height / 5);
        body = this.addPolygonBody(ramp, #static, 1.0, 1.0, 0.0, ramp.width, ramp.height);
        body.angle = Math.PI / 7;
        body.setPosition(2*width*ground.width / 4, System.height + ramp.height / 5);
        body = this.addPolygonBody(ramp, #static, 1.0, 1.0, 0.0, ramp.width, ramp.height);
        body.angle = Math.PI / 7;
        body.setPosition(3*width*ground.width / 4, System.height + ramp.height / 5);

    }

    function refresh()
    {
        this._bike.destroy(this);
        this._bike.create(this, System.width / 2, 6 * System.height / 10);
        this._speedPaint.shader = this._createSpeedShader(System.height / 2);
        this._anglePaint.shader = this._createAngleShader(System.height / 2);
    }

    function _createPaint()
    {
        this._bg = new Paint();
        var pts = {
            start: {x: 0, y: 0},
            end: {x: 0, y: System.height},
        }; 
        //define array of colors (red, green, blue) in hexadecimal format [canal + RGB].
        var clrs = new Array(0xff0094ff, 0xff00d1ff);
        // define array of position
        var pos = new Array(0, 1);
        // creates shader of linear gradient 
        this._bg.shader = Shader.linear(pts, clrs, pos, 0);

        this._speedPaint = new Paint();
        this._speedPaint.shader = this._createSpeedShader(System.height / 2);
        this._anglePaint = new Paint();
        this._anglePaint.shader = this._createAngleShader(System.height / 2);

        this._textPaint = new Paint();
        this._textPaint.textSize = 20;
        var (w, h) = this._textPaint.measureText("speed up");
        this._speedUpWidth = w;
        (w, h) = this._textPaint.measureText("speed down");
        this._speedDownWidth = w;
        (w, h) = this._textPaint.measureText("front up");
        this._speedFrontUp = w;
        (w, h) = this._textPaint.measureText("front down");
        this._speedFrontDown = w;
    }
}