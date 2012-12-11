include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://gfx.ms"

var p = 10;

// custom game class
class SampleThread : Game
{

    function start()
    {
        super.start();
        // additional initialization code goes here

       System.exec({
            command : "thread",
            file : "app://thread1.ms",
            callback : function(res) { console<<"end of thread1 "<<res<<"\n"; },
            input : "",
        })

        console<<"1\n";
        // load graphical resources
       // GFX.load();

        // prepare game

    }

}

// create instace and run the game
new SampleThread().run();
