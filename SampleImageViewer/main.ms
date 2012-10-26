include "lib://game2d/game.ms"

include "app://photoList.ms"

var game = new Game();

game.onStart = function()
{
    // create photolist
    this._photoList = new PhotoList();
    this.push(this._photoList);
    // set supported orientations
    this.orientation = [#portrait, #landscape-left];
}

game.onOrientationChanged = function(orientation)
{
    // resize all photos to current orientation
    for (var i in this._photoList.photos) {
        i.y = System.height / 2;
        i.resizePhoto();
    }
    // place the photo to the current position
    this._photoList.actualPhoto.x = System.width / 2;
    if (this._photoList.leftPhoto)
        this._photoList.leftPhoto.x = System.width / 2 - System.width;
    if (this._photoList.rightPhoto)
        this._photoList.rightPhoto.x = System.width / 2 + System.width;
}

game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #menu)
        game.quit();
}

game.run();