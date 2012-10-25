include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/analogTimer.ms"
include "app://scenes/digitalTimer.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        this._analogClock = new TextButton({text:"Analog clock", x:System.width/2, y:System.height/10*8});
        this._analogClock.onClick = function() {
            SFX.playClick();
            this super._playAnalogClock();
        }
        this.add(this._analogClock);

        this._digitalTimer = new TextButton({text:"Digital timer", x:System.width/2, y:System.height/10*9});
        this._digitalTimer.onClick = function() {
            SFX.playClick();
            this super._playDigitalTimer();
        }
        this.add(this._digitalTimer);
    }

    function _playAnalogClock()
    {
        Game.instance.push(new AnalogTimer(), new SlideToTop());
    }

    function _playDigitalTimer()
    {
        Game.instance.push(new DigitalTimer(), new SlideToTop());
    }

}
