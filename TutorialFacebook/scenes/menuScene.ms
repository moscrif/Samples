include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/singlePlayerScene.ms"
include "app://scenes/multiPlayerScene.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this.message = new Label({text : "Logged out", x : System.width / 2, y : System.height / 10});
        this.add(this.message);

        this._logInOut = new TextButton({text:"Log IN", x:System.width/2, y:3*System.height / 10});
        this._logInOut.onClick = function() {
            console<<"klik\n";
            SFX.playClick();
            this super._playLogInOut();
        }
        this.add(this._logInOut);

        // set login and logout callbacks
        this._setCallbacks();

        this._singlePlayer = new TextButton({text:"Single Player", x:System.width/2, y:System.height/10*8});
        this._singlePlayer.onClick = function() {
            SFX.playClick();
            this super._playSinglePlayer();
        }
        this.add(this._singlePlayer);

        this._multiPlayer = new TextButton({text:"Multi Player", x:System.width/2, y:System.height/10*9});
        this._multiPlayer.onClick = function() {
            SFX.playClick();
            this super._playMultiPlayer();
        }
        this.add(this._multiPlayer);
    }

    function _setCallbacks()
    {
        this.login = false;
        // login events
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
        }
        // logout events
        facebook.onLogout = function()
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
        }
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

    function _playSinglePlayer()
    {
        Game.instance.push(new SinglePlayerScene(), new SlideToTop());
    }

    function _playMultiPlayer()
    {
        Game.instance.push(new MultiPlayerScene(), new SlideToTop());
    }
}