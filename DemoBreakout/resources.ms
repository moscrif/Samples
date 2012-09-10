
class Resources
{
    // loaded elements (static object)
    var _loaded = {};
    var GFX_PATH = "app://gfx/";
    var SFX_PATH = "app://sfx/";

    function this()
    {
        var self = this;
        this.img = {
            ball        : Bitmap.fromFile(GFX_PATH + "ball-ingame.png"),
            brisks      : Bitmap.fromFile(GFX_PATH + "bricks.png"),
            levels      : Bitmap.fromFile(GFX_PATH + "levels.png"),
            gameOver    : Bitmap.fromFile(GFX_PATH + "gameOver.png"),
            disks       : Bitmap.fromFile(GFX_PATH + "disks.png"),
            playButton  : Bitmap.fromFile(GFX_PATH + "playbttn.png"),
            continueButton  : Bitmap.fromFile(GFX_PATH + "continuebttn.png"),
            quitButton  : Bitmap.fromFile(GFX_PATH + "quitbttn.png"),
            menuButton  : Bitmap.fromFile(GFX_PATH + "menu.png"),
            gameOver    : Bitmap.fromFile(GFX_PATH + "gameOver.png"),
            menuBg      : self.loadBg(GFX_PATH + "bgr-intro-"),
            gameBg      : self.loadBg(GFX_PATH + "bgr-ingame-"),
            logo        : self.loadLogo(GFX_PATH + "img_intro_"),
        };
    
        this.resizeButtons();
    
        this.sounds = {
            ball        : SFX_PATH + "ball.wav",
            strikeball  : SFX_PATH + "strikeball.wav",
            eletric     : SFX_PATH + "electricshock.wav",
        };
    
        this.values = {
            levelChangingInterval : 1500,
            electricShockMin : 1500,
            electricShockGap : 2000,
            formAnimationTime : 800,
        }
    }

    // adjust size of menu bottons to the svreen resolution
    function resizeButtons()
    {
        var scale = 1.0;
        if (this.img.continueButton.width > 4.0 * System.width / 5) {
            scale = (4.0*System.width / 5) / this.img.continueButton.width;
            this.img.playButton = this.img.playButton.resize((this.img.playButton.width * scale).toInteger(), (this.img.playButton.height * scale).toInteger())
            this.img.quitButton = this.img.quitButton.resize((this.img.quitButton.width * scale).toInteger(), (this.img.quitButton.height * scale).toInteger())
            this.img.continueButton  = this.img.continueButton.resize((this.img.continueButton.width * scale).toInteger(), (this.img.continueButton.height * scale).toInteger())
        }
    }

    function loadBg(res)
    {
        if (System.width < 321)
            return Bitmap.fromFile(res + "320x480.jpg");
        else if (System.width < 481)
            return Bitmap.fromFile(res + "480x800.jpg");
        else if (System.width < 601)
            return Bitmap.fromFile(res + "600x800.jpg");
        else if (System.width < 641)
            return Bitmap.fromFile(res + "640x960.jpg");
        else if (System.width < 769)
            return Bitmap.fromFile(res + "768x1024.jpg");
        else
            return Bitmap.fromFile(res + "800x1280.jpg");
    }

    function loadLogo(res)
    {
        if (System.width < 321)
            return Bitmap.fromFile(res + "320x480.png");
        else if (System.width < 481)
            return Bitmap.fromFile(res + "480x800.png");
        else if (System.width < 601)
            return Bitmap.fromFile(res + "600x800.png");
        else if (System.width < 641)
            return Bitmap.fromFile(res + "640x960.png");
        else if (System.width < 769)
            return Bitmap.fromFile(res + "768x1024.png");
        else
            return Bitmap.fromFile(res + "800x1280.png");
    }
}