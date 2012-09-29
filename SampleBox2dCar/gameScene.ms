class GameScene : PhysicsScene
{
    function init()
    {
        super.init();

        // create physics world
        this.world = new b2World(0.0, -9.8, true, false);
        this.world.setContinuousPhysics(false);

        this.width = 2*System.width;
        this._translateX = 0;
        this._translateY = 0;
        this._x = 0;

        // create car
        this._car = new Car();
        this._car.create(this, System.width / 2, 1* System.height / 10);
        // allow debug drawing
        this.debugDraw = true;
        this._createGround();

        this.menu = new Menu({
            width       : System.width,
            height      : System.height, z : 3,
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
       var (x, y) = this._car.getPosition();

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
        this._x += this._translateX;
        this._translateX = 0;

        super.draw(canvas);
        canvas.restore();

    }

    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);

        this._timer = new Timer(10, true);
        if (x < System.width / 2)
            this._timer.onTick = function()
            {
                this super._car.speedDown();
            }
        else
            this._timer.onTick = function()
            {
                this super._car.speedUp();
            }
        this._timer.start(10);
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);

        this._timer.dispose();
    }

    function _createGround()
    {
        var width = 100;
        var ground = Bitmap.fromFile("app://ground.png");
        for (var i = 0; i < width; i++)
            this.addPolygonBody(ground, #static, 0.0, 1.0, 0.0, ground.width, ground.height).setPosition(ground.width/2 + i*ground.width, System.height - ground.height / 2 );

        var leftStop = this.addPolygonBody(Bitmap.fromFile("app://ground.png"), #static, 0.0, 0.0, 0.0, System.height, 1);
        leftStop.angle = Math.PI / 2;
        leftStop.setPosition(0, System.height / 2);

        var rightStop = this.addPolygonBody(Bitmap.fromFile("app://ground.png"), #static, 0.0, 0.0, 0.0, System.height, 1);
        rightStop.angle = Math.PI / 2;
        rightStop.setPosition(width*ground.width, System.height / 2);

        var rect = Bitmap.fromFile("app://rect.png");
        var scale = System.height / 600.0;
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
        this._car.destroy(this);
        this._car.create(this, System.width / 2, 1 * System.height / 10);
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
    }
}