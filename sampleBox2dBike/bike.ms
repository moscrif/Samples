class Bike
{
    function this()
    {
        // images
        this._images = {
            frame           : Bitmap.fromFile("app://bike/frame.png"),
            frontDamper     : Bitmap.fromFile("app://bike/frontDamper.png"),
            backDamper      : Bitmap.fromFile("app://bike/backDamper.png"),
            wheel           : Bitmap.fromFile("app://bike/wheel.png"),
        }
        // array of all joints
        this._joints = new Array();

        // apply angular impulse in regular intervals. The angular damping allows to create flip or stabilize bike after jump
        this._angularImpulse = 0.0;
        var process = new Timer(50, true);
        process.onTick = function()
        {
            this super._frame.applyAngularImpulse(this super._angularImpulse);
        }
        process.start(50);
    }

    function getPosition()
    {
        return this._frame.getPosition();;
    }

    function create(scene, x, y)
    {
        this._angularImpulse = 0.0;
       // polygon shape of the body
       var shape = [
            {x:-30,y:-82},
            {x:100,y:-42},
            {x:50,y:82},
            {x:38,y:80},
            {x:-98,y:46},
            {x:-92,y:-76}
        ]
        this._frame = scene.addPolygonBody(this._images.frame, #dynamic, 1.0, 0.0, 0.0, shape);
        this._frame.z = 2;
        this._frame.setPosition(x, y);
    
        // FRONT
        this._frontDamper = scene.addPolygonBody(this._images.frontDamper, #dynamic, 1.0, 0.0, 0.0, this._images.frontDamper.width, this._images.frontDamper.height);
        this._frontDamper.z = 3;
        this._frontDamper.setPosition(x + 96, y + 35);
    
        this._frontWheel = scene.addCircleBody(this._images.wheel, #dynamic, 1.2, 1.0, 0.0, this._images.wheel.width / 2);
        this._frontWheel.z = 2;
        this._frontWheel.setPosition(x + 113, y + 73);
    
        // BACK
        this._backDamper = scene.addPolygonBody(this._images.backDamper, #dynamic, 1.0, 0.0, 0.0, this._images.backDamper.width, this._images.backDamper.height);
        this._backDamper.z = 3;
        this._backDamper.setPosition(x - 80, y + 70);
    
        this._backWheel = scene.addCircleBody(this._images.wheel, #dynamic, 1.2, 1.0, 0.0, this._images.wheel.width / 2);
        this._backWheel.z = 2;
        this._backWheel.setPosition(x - 120, y + 80);

        // JOINTS
        // connect front damper onto frame
        var jointDef = {
            lowerTranslation    : -0.2, //(damperHeight / 5) / scene.scale,  /*meters*/
            upperTranslation    : 0.0,  /*meters*/
            enableLimit         : true,
            enableMotor         : true,
            motorSpeed          : 2.0,
            maxMotorForce       : this._frame.getMass() * 9.8,
        }
        this._joints.push(scene.createPrismaticJoint(this._frontDamper, this._frame, x + 96, y + 35, -0.4, 1.0, 0.0, jointDef, false));
        // connect back damper onto frame
        jointDef = {
            enableMotor     : true,     // enable motor
            maxMotorTorque  : 150,      // maximum torque
            motorSpeed      : -0.9,     // it is changed latery
            lowerAngle      : 0.2, //(damperHeight / 5) / scene.scale,  /*meters*/
            upperAngle      : 0.45,
            enableLimit     : true,
        }
        this._joints.push(scene.createRevoluteJoint(this._backDamper, this._frame, x - 50, y + 55, jointDef, false));

        // front wheel - without motor
        this._joints.push(scene.createRevoluteJoint(this._frontDamper, this._frontWheel, x + 113, y + 73, null, false));
        // back wheel - with motor
        jointDef = {
            enableMotor     : true,         // enable motor
            maxMotorTorque  : 1500000,         // maximum torque
            motorSpeed      : -2.0,         // it is changed latery*/
        }
        this._motorJoint = scene.createRevoluteJoint(this._backDamper, this._backWheel, x - 120, y + 80, jointDef, false);

        // deny contacts between some bodies
        this._joints.push(this._motorJoint);
        this._joints.push(scene.createMouseJoint(this._frame, this._backWheel, null, false));
        this._joints.push(scene.createMouseJoint(this._frame, this._frontWheel, null, false));
        this._joints.push(scene.createMouseJoint(this._frontDamper, this._frontWheel, null, false));
    }

    function destroy(scene)
    {
        // destroy all joints
        for (var i in this._joints)
            scene.destroyJoint(i);
        this._joints = new Array();

        // destroy all bodies
        scene.destroyBody(this._frame);
        scene.destroyBody(this._frontDamper);
        scene.destroyBody(this._frontWheel);
        scene.destroyBody(this._backDamper);
        scene.destroyBody(this._backWheel);
    }

    function getMass()
    {
        return this._frame.getMass();
    }

    property speed(v)
    {
        get return this._motorJoint.motorSpeed;
        set this._motorJoint.motorSpeed = v;

    }

    property player(v)
    {
        get this._angularImpulse;
        set this._angularImpulse = v;
    }
}