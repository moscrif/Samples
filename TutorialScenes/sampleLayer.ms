include "lib://game2d/layer.ms"

class SampleLayer : Layer
{
   function init()
    {
        super.init();

        this.width = System.width;
        this.height = System.height;
        this.left = 0;
        this.top = 0;

        // add label to the layer
        this.add(new Label({
            text    : "label from layer",
            x       : System.width / 2,
            y       : System.height / 5,
        }));
    }
}