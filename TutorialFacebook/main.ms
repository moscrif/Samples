include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"
include "app://sfx.ms"
include "app://scenes/menuScene.ms"

var facebook = null;


function fromValue(value)
    {
        var result = "";
        switch (typeof(value)) {
        case #array:
            result += "[";
            for (var i = 0; i < value.length; i++)
                result += fromValue(value[i]) + ", ";
            result = result.substring(0, result.length - 2) + "]";
            break;
        case #object:
            for (var item in value)/* {*/
                result = item + " = " + fromValue(value.propertyAt(item)) + ", " + result;

            result = "{" + result.substring(0, result.length - 2) + "}";
            break;
        case #Bitmap:
            result = "Bitmap (" + value.width + ", " + value.height + ") (" + typeof(value) + ")";
            break;
        default:
            result += value + " (" + typeof(value) + ")";
        }
        console<<"facebook says: "<<result<<"\n";
        System.messageBox(result);
    }

// custom game class
class TutorialFacebook : Game
{

    function start()
    {
        super.start();
        // load graphical resources
        GFX.load();

        // load sound and musics
        SFX.load();

        // get acces to the facebook
        facebook = new Facebook("123953091087655", ["offline_access", "status_update", "read_stream", "publish_stream", "publish_actions"]);
        if(!facebook) {
            System.messageBox("Could not create a facebook client!!");
            return;
        }
        facebook.onLogin = function()
        {
            System.messageBox("login");
            /*var self = this super;
        
            self.login = true;
            self._logInOut.text = "Logout";
            self.message = "Logged in";*/
        }
        facebook.onLoginFailed = function(status)
        {

            System.messageBox("login failure");
            console<<"on login failed "<<status<<"\n";
           /* var self = this super;
        
            self.login = false;
            self._logInOut.text = "Login";
            self.message = "Login failed!";*/
        }
        console<<"seted callbacks\n";

        // add menu scene
        this.push(new MenuScene());
    }

    function draw(canvas)
    {
        // custom drawings - background
        canvas.drawBitmap(GFX.background, 0, 0);

        // default drawings
        super.draw(canvas);
    }

    function keyPressed()
    {
    console<<"keyPred\n";
        this.quit();
    }

}

// create instace and run the game
new TutorialFacebook().run();
