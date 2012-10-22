include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class RequestScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text:"Requests", y:System.height / 10, x:System.width/2}));

        var sendStatus = new TextButton({text:"send status", x:System.width/2, y:System.height/10*3});
        sendStatus.onClick = function() {
            this super._doSendStatus();
        }
        this.add(sendStatus);

        var sendLink = new TextButton({text:"send link", x:System.width/2, y:System.height/10*4});
        sendLink.onClick = function() {
            this super._doSendLink();
        }
        this.add(sendLink);

        var sendPhoto = new TextButton({text:"send photo", x:System.width/2, y:System.height/10*5});
        sendPhoto.onClick = function() {
            this super._doSendPhoto();
        }
        this.add(sendPhoto);

        var getFriends = new TextButton({text:"get friands", x:System.width/2, y:System.height/10*6});
        getFriends.onClick = function() {
            this super._doGetFriends();
        }
        this.add(getFriends);

        /*var payDialog = new TextButton({text:"pay dialog", x:System.width/2, y:System.height/10*6});
        payDialog.onClick = function() {
            this super._doPayDialogVideo();
        }
        this.add(payDialog);

        var requestDialog = new TextButton({text:"request dialog", x:System.width/2, y:System.height/10*7});
        requestDialog.onClick = function() {
            this super._doRequestDialog();
        }
        this.add(requestDialog);

        var sendDialog = new TextButton({text:"send dialog", x:System.width/2, y:System.height/10*8});
        sendDialog.onClick = function() {
            this super._doSendDialog();
        }
        this.add(sendDialog);*/

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);

        facebook.onRequest = function(result)
        {
            console<<"on request " << result.toString()<<"\n";
            fromValue(result);
        }

        facebook.onRequestFailed = function(error)
        {
            console<<"on request failure\n";
        }
    }

    function _doSendStatus()
    {
        facebook.request("me/feed", #post, {title: "Moscrif Test", type: "status", message: "Moscrif test status", description: "Moscrif test status description."});
    }

    function _doSendLink()
    {
        facebook.request("me/feed", #post, {title: "Moscrif Test", type: "link", link: "http://moscrif.com", picture: "http://moscrif.com/images/logo.png", description: "Moscrif test."})
    }

    function _doSendPhoto()
    {
        var bitmap = Bitmap.fromFile("app://foto.jpg");
        facebook.request("me/photos", #post, {title: "Moscrif Test", source: bitmap, message: "Moscrif Test.", description: "Moscrif test."});
    }

    function _doGetFriends()
    {
        var bitmap = Bitmap.fromFile("app://foto.jpg");
        facebook.request("me/photos", #post, {title: "Moscrif Test", source: bitmap, message: "Moscrif Test.", description: "Moscrif test."});
    }

    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }
}
