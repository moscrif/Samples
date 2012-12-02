include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/galaxyScene.ms"
include "app://scenes/snowScene.ms"
include "app://scenes/cometScene.ms"
include "app://scenes/fireScene.ms"
include "app://scenes/fireScene2.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this._fire = new TextButton({text:"Fire effect2", x:System.width/2, y:System.height/10*5});
        this._fire.onClick = function() {
            this super._playFire2();
        }
        this.add(this._fire);

        this._fire = new TextButton({text:"Fire effect", x:System.width/2, y:System.height/10*6});
        this._fire.onClick = function() {
            this super._playFire();
        }
        this.add(this._fire);

        this._comet = new TextButton({text:"Comet effect", x:System.width/2, y:System.height/10*7});
        this._comet.onClick = function() {
            this super._playComet();
        }
        this.add(this._comet);

        this._galaxy = new TextButton({text:"Spiral / galaxy effect", x:System.width/2, y:System.height/10*8});
        this._galaxy.onClick = function() {
            this super._playGalaxy();
        }
        this.add(this._galaxy);

        this._snow = new TextButton({text:"Snow effect", x:System.width/2, y:System.height/10*9});
        this._snow.onClick = function() {
            this super._playSnow();
        }
        this.add(this._snow);
    }

    function _playComet()
    {
        Game.instance.push(new CometScene(), new SlideToTop());
    }

    function _playSnow()
    {
        Game.instance.push(new SnowScene(), new SlideToTop());
    }

    function _playGalaxy()
    {
        Game.instance.push(new GalaxyScene(), new SlideToTop());
    }

    function _playFire()
    {
        Game.instance.push(new FireScene(), new SlideToTop());
    }
    function _playFire2()
    {
        Game.instance.push(new FireScene2(), new SlideToTop());
    }
}