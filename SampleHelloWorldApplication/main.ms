include "lib://uix/application.ms"
include "lib://uix-skin/metro/skin.metro.ms"
include "lib://uix/form.ms"
include "lib://uix/control/label.ms"
include "lib://uix/control/textBox.ms"
include "lib://uix/control/button.ms"
include "lib://uix/control/navigation/titleBar.ms"

include "app://forms/firstForm.ms"
include "app://forms/secondForm.ms"

var userName;
var userSurname;

var app = new Application({skin : new MetroSkin()});

app.onStart = function()
{
    this.push(new FirstForm())
}

app.run();