include "lib://core/log.ms"                     // log stuff
include "lib://core/animation/animator.ms"                // animator class

var win = new Moscrif.Window();                 // main window object
var quit = false;                               // set quit to true for application exit
var background = null;                          // background image
var menu = [];                                  // array of menu (images)

function moveVertTo(image, dst, duration)
{
    const delta = 500;                          // offset
    image.left = dst.left;                      // left side has fixed position
    image.top = dst.top + delta;                // move by offest by default
    image.visible = true;                       // for drawing method only
    var animator = new Animator({
        transition: Animator.Transition.easeIn, // start up slowly and then quickly speed up at the end of the animation
        duration: duration,                     // length of animation in miliseconds
    });
    animator.addSubject(function(state) {       // state starts from 1.0 to 0.0
        image.top = dst.top + Math.floor(state * delta);
        win.invalidate();                       // force repaint
    })
    animator.reverse();                         // animator.play() goes from 0..1, but we want 1..0
}

win.onStart = function()                  // called when app starts
{
    background = Bitmap.fromFile("app://menu_back.png");
    background = background.resize(System.width, System.height);

    var maxWidth = 0;
    var img1 = Bitmap.fromFile("app://text_continue.png");
    if (maxWidth < img1.width)
        maxWidth = img1.width;

    var img2 = Bitmap.fromFile("app://text_gyro.png");
    if (maxWidth < img2.width)
        maxWidth = img2.width;

    var img3 = Bitmap.fromFile("app://text_touch.png");
    if (maxWidth < img3.width)
        maxWidth = img3.width;

    var img4 = Bitmap.fromFile("app://text_quit.png");
    if (maxWidth < img4.width)
        maxWidth = img4.width;

    // resize menu buttons if needed
    if (maxWidth > 9 * System.width / 10) {
        var scale = (9.0 * System.width/ 10) / maxWidth;
        img1 = img1.resize((img1.width * scale).toInteger(), (img1.height * scale).toInteger());5
        img2 = img2.resize((img2.width * scale).toInteger(), (img2.height * scale).toInteger());
        img3 = img3.resize((img3.width * scale).toInteger(), (img3.height * scale).toInteger());
        img4 = img4.resize((img4.width * scale).toInteger(), (img4.height * scale).toInteger());
    }

    // add items to the menu
    menu.push(img1);
    menu.push(img2);
    menu.push(img3);
    menu.push(img4);

    // Timer object that schedules one tick only
    var delayAndTickOnce = new Timer(1, 1);     // the first parameter is ignored when second one is number of the tick
    delayAndTickOnce.onTick = function(sender) {
        moveVertTo(img1, {left: (System.width - img1.width )/ 2, top: System.height / 2}, 100);
        moveVertTo(img2, {left: (System.width - img2.width )/ 2, top: 6 * System.height / 10}, 125);
        moveVertTo(img3, {left: (System.width - img3.width )/ 2, top: 7 * System.height / 10}, 150);
        moveVertTo(img4, {left: (System.width - img4.width )/ 2, top: 8 * System.height / 10}, 175);
    }
    delayAndTickOnce.start(1000);               // start after 1000ms
}

win.onProcess = function(sender)
{
    return quit ? 0 : 1;
}

win.onPointerReleased = function(sender, x, y) // quit on touch
{
    quit = true;
}

win.onKeyPressed = function(sender, key)
{
    if (key == #quit || key == #back)
        quit = true;
}

win.onDraw = function(sender, canvas)          // draw backround and menu's images
{
    canvas.drawBitmap(background, 0, 0);
    for (var m in menu)
        if (m.visible)
            canvas.drawBitmap(m, m.left, m.top);
}

win.init().run();                              // initialize & run app

// eof
