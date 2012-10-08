include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"

include "app://scenes/rotateScene.ms"
include "app://scenes/pinchScene.ms"
include "app://scenes/swipeScene.ms"
include "app://scenes/panScene.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this._rotateGesture = new TextButton({text:"Rotate gesture", x:System.width/2, y:System.height/10*5});
        this._rotateGesture.onClick = function() {
            SFX.playClick();
            this super._addRotateScene();
        }
        this.add(this._rotateGesture);

        this._pinchGesture = new TextButton({text:"Pinch gesture", x:System.width/2, y:System.height/10*6});
        this._pinchGesture.onClick = function() {
            SFX.playClick();
            this super._addPinchScene();
        }
        this.add(this._pinchGesture);

        this._swipeGesture = new TextButton({text:"Swipe gesture", x:System.width/2, y:System.height/10*7});
        this._swipeGesture.onClick = function() {
            SFX.playClick();
            this super._addSwipeScene();
        }
        this.add(this._swipeGesture);

        this._panGesture = new TextButton({text:"Pan gesture", x:System.width/2, y:System.height/10*8});
        this._panGesture.onClick = function() {
            SFX.playClick();
            this super._addPanScene();
        }
        this.add(this._panGesture);
    }

    function _addRotateScene()
    {
        Game.instance.push(new RotateScene(), new SlideToTop());
    }

    function _addPinchScene()
    {
        Game.instance.push(new PinchScene(), new SlideToTop());
    }

    function _addSwipeScene()
    {
        Game.instance.push(new SwipeScene(), new SlideToTop());
    }

    function _addPanScene()
    {
        Game.instance.push(new PanScene(), new SlideToTop());
    }
}