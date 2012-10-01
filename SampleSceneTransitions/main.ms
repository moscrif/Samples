include "lib://game2d/game.ms"
include "lib://game2d/scene.ms"
include "lib://game2d/textButton.ms"
include "lib://game2d/sceneTransitions/slideToLeft.ms"
include "lib://game2d/sceneTransitions/slideToRight.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://gameScene.ms"
include "app://ownTransition.ms"

var game = new Game();

//define sample scene and scene buttons
game.onStart = function()
{
    //game scene instance
    var scene = new GameScene();
    this.push(scene);

    //text decoration object
    var textBold = new Paint();
    textBold.textSize = System.height/20;
    textBold.typeface = Typeface.fromName("mailrays", #bold);
    textBold.color = 0xffffffff;

    //create buttons
    var btnTop = new TextButton({text: "Top", paint: textBold,x:System.width/2,y:System.height/2+System.height/15});
    btnTop.onClick = function() {
       //scene transition to top
       this super.push(scene, new SlideToTop({duration:1000, transition:Animator.Transition.bouncy}));
    };
    scene.add(btnTop);

    var btnBottom = new TextButton({text: "Bottom", paint: textBold,x:System.width/2,y:System.height/2+System.height/15*2});
    btnBottom.onClick = function() {
       //scene transition to Bottom
       this super.push(scene, new SlideToBottom({duration:1000, transition:Animator.Transition.bouncy}));
    };
    scene.add(btnBottom);

    var btnLeft = new TextButton({text: "Left", paint: textBold,x:System.width/2,y:System.height/2+System.height/15*3});
    btnLeft.onClick = function() {
       //scene transition to Left
       this super.push(scene, new SlideToLeft({duration:1000, transition:Animator.Transition.bouncy}));
    };
    scene.add(btnLeft);

    var btnRight = new TextButton({text: "Right", paint: textBold,x:System.width/2,y:System.height/2+System.height/15*4});
    btnRight.onClick = function() {
       //scene transition to Right
       this super.push(scene, new SlideToRight({duration:1000, transition:Animator.Transition.bouncy}));
    };
    scene.add(btnRight);

    var btnOwnTransition = new TextButton({text: "Own transition", paint: textBold,x:System.width/2,y:System.height/2+System.height/15*5});
    btnOwnTransition.onClick = function() {
        //own scene transition
        this super.push(scene, new OwnTransition({duration:1000, transition:Animator.Transition.bouncy}));
    };
    scene.add(btnOwnTransition);

    var btnQuit = new TextButton({text: "Quit", paint: textBold,x:System.width/2,y:System.height/2+System.height/15*6});
    btnQuit.onClick = function() {
        // quit game
        game.quit();
    };
    scene.add(btnQuit);

}

// user event
game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        game.quit();
}

//run sample
game.run();