// create new instance of Window class
var app = new Moscrif.Window();
var quit = false;

// @region system events
app.onStart = function(sender)
{
    //text during picture loading
    this._text = "loading...";
    // error indicator, false if no error appeared
    this._error = false;

    //text decorator object
    this._paint = new Paint();
    this._paint.typeface = Typeface.fromName("freemono", #bold);
    this._paint.textSize = System.height / 30;
    this._paint.color = 0xff000000;

    this._img = null;

    // Create web client (download from http://moscrif.com/userfiles/moscrif2.png)
    var wc = new WebClient();

    // connect to the server
    wc.open("moscrif.com", 80, false, "");
    // show error message if some error appeared
    wc.onError = function(sender) {
        this super._error = true;
        this super.invalidate();
    }
    // show number of received bytes
    wc.onReceiving = function(sender, received, total) {
        // total can be 0, depends on the server behaviour
        this super._text = String.printf("receved %d bytes...", received);
        this super.invalidate();
    }
    // show image, when it is downloaded
    wc.onReceived = function(sender) {
        // transfer dota into bitmap
        this super._img = Bitmap.fromBytes(this.data);
        this super.invalidate();
    }
    wc.onCancel = function(sender) {
        this super._text = "cancelled!";
        this super.invalidate();
    }
    //get picture from the server (from [server address]/userfiles/moscrif2.png)
    wc.getData("/userfiles/moscrif2.png");

    app.invalidate()
}

app.onDraw = function(sender, canvas)
{
    // fill whole screen by white color
    canvas.clear(0xffffffff);
    // check if no error appeared
    if (this._error) {
        // show error message
        // 1th line
        var (w, h) = this._paint.measureText("An error appeared!");
        canvas.drawText("An error appeared!", (System.width - w)/2, (System.height)/4, this._paint);
        // 2nd line
        (w, h) = this._paint.measureText("Please,");
        canvas.drawText("Please,", (System.width - w)/2, (System.height)/2, this._paint);
        // 3th line
        (w, h) = this._paint.measureText("check internet connection!");
        canvas.drawText("check internet connection!", (System.width - w)/2, (System.height)/2 + 2*h, this._paint);
        // 4th line
        (w, h) = this._paint.measureText("Tap to quit");
        canvas.drawText("Tap to quit", (System.width - w)/2, 3 * (System.height)/4, this._paint);
        // end drawing
        return;
    }
    // if image has been downloaded show it
    if (this._img) {
        var x = (System.width - this._img.width) / 2;
        var y = (System.height - this._img.height) / 2;
        canvas.drawBitmap(this._img, x, y);
    // othewise show text
    } else {
        var (h, w) = this._paint.measureText(this._text);
        canvas.drawText(this._text, (System.width - w)/2, (System.height - h)/2, this._paint);
    }
}

// onProcess event must return some value in native applications (0 - quit, 1 - redraw, 2 - continue)
app.onProcess = function(sender)
{
    if (quit)
        return 0;
    else
        return 1;
}

app.onPointerPressed = function()
{
    // if user tap onto screen, on error message quit application
    if (this._error)
        quit = true;

}

app.onKeyPressed = function(sender, keyCode)
{
    if (keyCode == #back || keyCode == #menu)
        quit = true;
}
// @endregion

// init and run application
app.init().run();