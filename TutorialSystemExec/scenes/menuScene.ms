include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this._call = new TextButton({text:"call", x:System.width/2, y:System.height/10});
        this._call.onClick = function() {
            this super._makeCall();
        }
        this.add(this._call);

        this._email = new TextButton({text:"send email", x:System.width/2, y:2*System.height/10});
        this._email.onClick = function() {
            this super._makeEmail();
        }
        this.add(this._email);

        this._sms = new TextButton({text:"send sms", x:System.width/2, y:3*System.height/10});
        this._sms.onClick = function() {
            this super._makeSms();
        }
        this.add(this._sms);

        this._photo = new TextButton({text:"take photo", x:System.width/2, y:4*System.height/10});
        this._photo.onClick = function() {
            this super._makePhoto();
        }
        this.add(this._photo);

        this._web = new TextButton({text:"open web", x:System.width/2, y:5*System.height/10});
        this._web.onClick = function() {
            this super._makeWeb();
        }
        this.add(this._web);
    }

    function _makeCall()
    {
        System.exec({
            command : "call-to",
            phone   : "00991111222333",
    
        });
    }

    function _makeEmail()
    {
        System.exec ({
            command : "mail-to",
            to      : "test@testtutorial.com",
            cc      : "copy to",
            bcc     : "blind carbon copy",
            subject : "mail subject",
            body    : "text of mail",
        });
    }
    
    function _makeSms()
    {
       //"sms-to"
        System.exec ({
            command : "sms-to",
            to      : "00991111222333",
            text    : "message text"
        });
    }

    function _makePhoto()
    {
        var callback = function()
        {
            // call back method
        }
        System.exec({
            command     : "take-image",
            file        : "dat://image.jpg",
            callback    : callback,
        });
    }

    function _makeWeb()
    {
        System.exec({
            command : "open-url",
            url     : "http://www.moscrif.com",
        });
    }
}
