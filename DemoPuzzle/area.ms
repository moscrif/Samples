include "lib://core/animation/transition.ms"
include "lib://game2d/scene.ms";
include "app://part.ms";

class Area : Scene
{
    // @region Construction

    function init()
    {
        super.init();
        this._parts = new Array();
        this._catchImage = #nothing;

        this._background = Bitmap.fromFile( GFX_PATH + "bgr.png");
        // calculate center position
        this._backgroundLeft = (System.width - this._background.width) / 2;
        this._backgroundTop = (System.height - this._background.height) / 2;

        this._negative = Bitmap.fromFile( GFX_PATH + "negative.png");
        // calculate center position
        this._negativeLeft = (System.width - this._negative.width) / 2;
        this._negativeTop = (System.height - this._negative.height) / 2;

        this._final = Bitmap.fromFile( GFX_PATH + "crocodile.png");
        this._finalLeft = (System.width - this._final.width) / 2;
        this._finalTop = (System.height - this._final.height) / 2;

        var cx = System.width / 2;
        var cy = System.height / 2;

        this._positions = [
            [cx - 73, cy - 324], [cx - 17, cy - 287], [cx - 160, cy - 244],
            [cx - 82, cy - 185], [cx - 197, cy - 84], [cx - 142, cy - 45],
            [cx - 57, cy - 59], [cx - 156, cy + 59],  [cx - 2, cy + 102],
            [cx - 135, cy + 154], [cx + 25, cy + 156], [cx - 44, cy + 247] ];

        for (var i = 1; i<13; i++)
            this._addPart(GFX_PATH + "part"+i+"a.png", this._positions[i-1][0], this._positions[i-1][1]);

        this._onPlace = this._parts.length;
    }

    // @endregion

    /**
    @param fileName String Path to the image.
    @param x Integer Position on x axis.
    @param y Integer Poistion on y axis.
    @param funct Function Function called at click on the button.
    */
    function addButton(fileName, x, y, funct)
    {
        var button = new ImageButton({image: fileName, x: x, y: y, onClick: funct});
        this.add(button);
    }

    /**
    Called when this scene becomes active
    */
    function enter()
    {
        super.enter();
        this._pulseButtons();
    }

    /**
    Function, which set objects to the init state.
    */
    function restart()
    {
        // go throw all objects in this._parts array
        for (var part in this._parts) {
            part.isOnPlace = false;
            // find new position for this part
            this._findPosition(part);
        }
        this._onPlace = 0;
        this._pulseButtons();
    }

    /**
    Event fired at redraw scene.
    @param canvas Canvas
    */
    function draw(canvas)
    {
        canvas.save();

        canvas.drawBitmap(this._background, this._backgroundLeft, this._backgroundTop);
        canvas.drawBitmap(this._negative, this._negativeLeft, this._negativeTop);

        if (!this._victory()) {
            //draw all images on theirs positions
            for (var part in this._parts)
                part.draw(canvas);
        } else {
            //draw final picture after puzzle is solved
            canvas.drawBitmap(this._final, this._finalLeft, this._finalTop);
        }

        for (var control in this._controls)
            control.draw(canvas);

        canvas.restore();
    }

    /**
    Event fired at pointer pressed.
    @param x Integer Position on x axis
    @param y Integer Position on y axis
    */
    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);
        if (!this._victory())
            this._catchImage = this._getPart(x,y);
        else
            this.restart();
    }

    /**
    Event fired at pointer dragged.
    @param x Integer Position on x axis
    @param y Integer Position on y axis
    */
    function pointerDragged(x, y)
    {
        super.pointerDragged(x, y);
        if (this._catchImage != #nothing) {
            this._catchImage.x = x;
            this._catchImage.y = y;
            this._catchImage.push(this);
        }
    }

    /**
    Event fired at pointer released.
    @param x Integer Position on x axis
    @param y Integer Position on y axis
    */
    function pointerReleased(x,y)
    {
        super.pointerReleased(x,y);
        this._catchImage = #nothing;
    }


    /**
    Add new part to the scene.
    @param fileName String Path to the image.
    @param x Integer Position on x axis, where should be part location.
    @param y Integer Position on y axis, where should be part location.
    */
    function _addPart(fileName, x, y)
    {
        var part = new Part({image: fileName, locX: x, locY: y});
        this.add(part);
        this._parts.push(part);
    }

    /**
    Return part by coordinates.
    @param x Integer Position on x axis.
    @param y Integer Position on y axis.
    @return Part
    */
    function _getPart(x, y)
    {
        //Auxiliary variable, which remember picture located on position x y.
        //init state is nothing
        var searchPart = #nothing;

        //search image located on position x y
        for (var part in this._parts) {
            if (part.intersectsPoint(x, y))
                searchPart = part;
        }

        //If it found some image on position.
        if (searchPart != #nothing) {
            //set relative position
            searchPart.relX = searchPart.x - x;
            searchPart.relY = searchPart.y - y;

            //Move up
            this._moveUp(searchPart);
        }

        return searchPart;
    }

    /**
    Set to the part new random position.
    @param part Part
    */
    function _findPosition(part)
    {
        //Helper function
        function random(from, to) { return from + rand(to-from+1); }

        // number of runnig of the while.
        var counter = 0;
        while (counter < 100/*Max repeats*/ ) {
            counter ++;
            //Set random position on axis y.
            part.y = random(part.height/2,System.height-part.height/2);
            //If y coordinate is over crocodile
            if (part.y+part.height/2 < this._finalTop)
                part.x = random(part.width/2, System.width - part.width/2);
            else {
                //Choose one from two areas (left from crocodile and right from him).
                var area = rand(2);
                if (area == 0)
                    part.x = random(part.width/2, this._finalLeft-part.width/2);
                else
                    part.x = random(this._finalLeft + this._final.width,
                                        System.width-part.width/2);
            }
            //Check if this picture isnt in collision with other pictures.
            var collision = false;

            for (var p in this._parts) {
                if (part.intersectsBounds(p)) {
                    collision = true;
                    break;
                }
            }
            //If isnt in collision, it jumps from while loop.
            if (!collision)
                break;
        }
    }

    /**
    Move up part.
    @param part Part
    */
    function _moveUp(part)
    {
        this._parts.removeByValue(part);
        this._parts.push(part);
    }

    /**
    Check if game is in victory state.
    @return Boolean
    */
    function _victory()
    {
        return (this._onPlace == this._parts.length);
    }

    /**
    Helper function that implements simple pulse effect
    */
    function _pulse(obj)                            // fade in then pulse
    {
        var scale1 = Transition.to(obj, {
            transition: Animator.Transition.easeInOut, duration: 150,
            scale: 0.8
        }, false);
        var scale2 = Transition.to(obj, {
            transition: Animator.Transition.easeInOut, duration: 200,
            scale: 1.2
        }, false);
        var scale3 = Transition.to(obj, {
            transition: Animator.Transition.easeInOut, duration: 100,
            scale: 1.0
        }, false);
        new AnimatorChain([scale1, scale2, scale3]).play();
    }

    /**
    Pulses all buttons belongs to this scene
    */
    function _pulseButtons()
    {
        for (var obj in this._controls)
            if (obj instanceof ImageButton)
                this._pulse(obj);
    }

}