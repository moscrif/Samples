include "lib://game2d/game.ms"
include "lib://game2d/textButton.ms"
include "lib://game2d/scene.ms"
include "lib://game2d/label.ms"

include "app://sensor.ms"
include "app://sensorScene.ms"

var game = new Game()
var sensor = null;

game.onStart = function()
{
    sensor = new SensorClass();
    this.push(new SensorScene());
}

game.onKeyPressed = function(sender, keyCode)
{
    if (keyCode == #back || keyCode == #menu)
        game.quit();
}

game.run();