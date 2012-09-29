class Car
{
    function this()
    {
        this._images = {
            wheel   : Bitmap.fromFile("app://wheel.png"),
            body    : Bitmap.fromFile("app://car.png"),
        }
        this._scale = 1;//System.width / 500.0;
        this._speedStep = Math.PI / 2;

        this._joints = new Array();
        this._bodies = new Array();
    }

    function getPosition()
    {
        return this._body.getPosition();;
    }

    function create(scene, x, y)
    {
        var damperHeight = 8*this._images.wheel.width * this._scale/10;
        var wheelDistance = 7 * this._images.body.width*this._scale / 10;

        var bodyWidth = this._scale * this._images.body.width;
        var bodyHeight = this._scale * this._images.body.height;
        // create shassie
        var shape = [
            {x:122,y:7},
            {x:11,y:51},
            {x:-45,y:50},
            {x:-137,y:-4},
            {x:-150,y:-40},
            {x:-69,y:-54},
            {x:140,y:-50},
            {x :150,y:-21}
       ]

        this._body = scene.addPolygonBody(this._images.body, #dynamic, 0.1, 0.0, 0.0, shape);//this._images.body.width, this._images.body.height);
        this._body.z = 2;
        this._body.scale = this._scale;
        this._body.setPosition(x, y);
       
        // FRONT
        this._frontDamper = scene.addPolygonBody(null, #dynamic, 10.0, 0.0, 0.0, 2, this._images.wheel.width / 2 * this._scale);
        this._frontDamper.setPosition(x + wheelDistance / 2, y + damperHeight - this._images.wheel.width / 4 * this._scale);
    
        this._frontWheel = scene.addCircleBody(this._images.wheel, #dynamic, 0.1, 0.4, 0.0, this._images.wheel.width / 2 * this._scale);
        this._frontWheel.scale = this._scale;
        this._frontWheel.setPosition(x + wheelDistance / 2, y + damperHeight);
    
        // BACK
        this._backDamper = scene.addPolygonBody(null, #dynamic, 10.0, 0.0, 0.0, 2, this._images.wheel.width / 2 * this._scale);
        this._backDamper.setPosition(x - wheelDistance / 2, y + damperHeight - this._images.wheel.width / 4 * this._scale);
    
        this._backWheel = scene.addCircleBody(this._images.wheel, #dynamic, 0.1, 0.4, 0.0, this._images.wheel.width / 2 * this._scale);
        this._backWheel.scale = this._scale;;
        this._backWheel.setPosition(x - wheelDistance / 2, y + damperHeight);
    
        // JOINTS
        // prismatic joins
        var jointDef = {
            lowerTranslation    : -3 * (damperHeight / scene.scale) / 10, //(damperHeight / 5) / scene.scale,  /*meters*/
            upperTranslation    : 0.0,  /*meters*/
            enableLimit         : true,
            enableMotor         : true,
            motorSpeed          : 2.5,
            maxMotorForce       : this._body.getMass() * 8.5,
        }
        this._joints.push(scene.createPrismaticJoint(this._frontDamper, this._body, x + wheelDistance / 2, y, 0.0, 1.0, 0.0, jointDef, false));
        this._joints.push(scene.createPrismaticJoint(this._backDamper, this._body, x - wheelDistance / 2, y, 0.0, 1.0, 0.0, jointDef, false));
    
        // revolute joints
        jointDef = {
            enableMotor     : true,         // enable motor
            maxMotorTorque  : 1500000,         // maximum torque
            motorSpeed      : 0.0,         // it is changed latery*/
        }
       this._motorJoint = scene.createRevoluteJoint(this._frontDamper, this._frontWheel, x + wheelDistance / 2, y + damperHeight, jointDef, false);
       this._motorJointB = scene.createRevoluteJoint(this._backDamper, this._backWheel, x - wheelDistance / 2, y + damperHeight, jointDef, false);
    
       this._joints.push(this._motorJoint);
       this._joints.push(this._motorJointB);
       this._joints.push(scene.createMouseJoint(this._body, this._frontWheel, null, false));
       this._joints.push(scene.createMouseJoint(this._body, this._backWheel, null, false));
    }



    function destroy(scene)
    {
        for (var i in this._joints)
            scene.destroyJoint(i);
        this._joints = new Array();

        scene.destroyBody(this._body);
        scene.destroyBody(this._frontDamper);
        scene.destroyBody(this._frontWheel);
        scene.destroyBody(this._backDamper);
        scene.destroyBody(this._backWheel);
    }

    function speedUp()
    {
        // check if motors does not have maximum speed
        if (this._motorJoint.motorSpeed > -12*Math.PI) {
            // speed motors up
            this._motorJoint.motorSpeed -= this._speedStep;
            this._motorJointB.motorSpeed -= this._speedStep;
        }
    }

    function speedDown()
    {
        if (this._motorJoint.motorSpeed < 12*Math.PI) {
            this._motorJoint.motorSpeed += this._speedStep;
            this._motorJointB.motorSpeed += this._speedStep;
        }
    }
}