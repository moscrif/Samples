include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/requestScene.ms"
include "app://scenes/dialogScene.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this.message = new Label({text : "Logged out", x : System.width / 2, y : System.height / 10});
        this.add(this.message);

        // set login and logout callbacks
        this._setCallbacks();

        this._logInOut = new TextButton({text:"Log IN", x:System.width/2, y:3*System.height / 10});
        this._logInOut.onClick = function() {
            console<<"klik\n";
            this super._playLogInOut();
        }
        this.add(this._logInOut);

        var dialogScene = new TextButton({text:"dialogs", x:System.width/2, y:System.height/10*4});
        dialogScene.onClick = function() {
            Game.instance.push(new DialogScene(), new SlideToTop());
        }
        this.add(dialogScene);

        var requestScene = new TextButton({text:"request", x:System.width/2, y:System.height/10*5});
        requestScene.onClick = function() {
            Game.instance.push(new RequestScene(), new SlideToTop());
        }
        this.add(requestScene);
    }

    function _setCallbacks()
    {
        this.login = false;
        // login events
       /* console<<"seted callbacks\n";
        facebook.onLogin = function()
        {
            console<<"on login\n";
            var self = this super;

            self.login = true;
            self._logInOut.text = "Logout";
            self.message = "Logged in";
        }
        facebook.onLoginFailed = function(status)
        {
            console<<"on login failed "<<status<<"\n";
            var self = this super;

            self.login = false;
            self._logInOut.text = "Login";
            self.message = "Login failed!";
        }*/
        // logout events
       /* facebook.onLogout = function()
        {
            console<<"on logout\n";
            var self = this super;

            self.login = false;
            self._logInOut.text = "Login";
            self.message = "Logged out!";
        }
        facebook.onLogoutFailed = function(status)
        {
            console<<"on logout failure\n";
            var self = this super;

            self.login = true;
            self._logInOut.text = "Logout";
            self.message = "Logout failed!";
        }*/
    }

    function _playLogInOut()
    {
        // logOn
        if (this.login == false) {
            facebook.login();
            console<<"log in\n";
        } else {
            facebook.logout();
            console<<"log out\n";
        }
    }
}