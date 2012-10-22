include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"

class DialogScene : Scene
{
    function init()
    {
        super.init();

        this.add(new Label({text:"Dialogs", y:System.height / 10, x:System.width/2}));

        var dialogBasic = new TextButton({text:"basic postg", x:System.width/2, y:System.height/10*3});
        dialogBasic.onClick = function() {
            this super._doDialogBasic();
        }
        this.add(dialogBasic);

        var dialogPhoto = new TextButton({text:"image post", x:System.width/2, y:System.height/10*4});
        dialogPhoto.onClick = function() {
            this super._doDialogPhoto();
        }
        this.add(dialogPhoto);

        var dialogLink = new TextButton({text:"link post", x:System.width/2, y:System.height/10*5});
        dialogLink.onClick = function() {
            this super._doDialogLink();
        }
        this.add(dialogLink);

        var dialogTo = new TextButton({text:"post for one user", x:System.width/2, y:System.height/10*6});
        dialogTo.onClick = function() {
            this super._doDialogTo();
        }
        this.add(dialogTo);

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);
    }

    function _doDialogBasic()
    {
        // basic dialog for user status without any attachement
        facebook.dialog("feed", {});
    }

    function _doDialogPhoto()
    {
        // post on the wall with attched photo and text
        facebook.dialog("feed", {caption: "Moscrif Logo", picture: "http://moscrif.com/images/logo.png", description: "Moscrif facebook tutorial"});
    }

    function _doDialogTo()
    {
        // post on the wall of moscrif page
        facebook.dialog("feed", {caption: "Moscrif Page", link: "http://moscrif.com/", description: "Moscrif facebook tutorial", to : "moscrif"});
    }


    function _goBack()
    {
        Game.instance.pop(new SlideToBottom());
    }

}
