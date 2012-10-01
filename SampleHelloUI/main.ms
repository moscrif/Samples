include "lib://uix/application.ms";
include "lib://uix/control/navigation/titleBar.ms";
include "lib://uix/control/navigation/toolBar.ms";
include "lib://uix/control/navigation/toolBarButton.ms";

//Create object Application and add skin
var app = new Application();


//Event called at init Application.
app.onStart = function (sender)
{
    //Create new Form and control objects.
    var form = new Form({name : "MainForm"});
    var title = new TitleBar({label : new Label({text:"Hello UI"})}); //Bar on top of the Form.


    var label = new Label({text: "Content goes here"});
    //stretch lable size to both
    label.stretch = #both;

    //Create ToolBar. It is a bar on bottom of the Form.
    var tools = new ToolBar();
    tools.name = "MyToolBar";
    //Buttons, which will add to ToolBar
    var menu = new ToolBarButton({name : "menu"});
    menu.icon = #menu;
    var quit = new ToolBarButton({name : "quit", icon: #close, onClick: function(){ app.quit();}});

    //Adding ToolBarButtons to the ToolBar
    tools.add(new ToolBarButton({name : "back", icon: #back}));
    tools.add(menu);
    tools.add(quit);
    //Adding objects to the Form
    form.add(title);
    form.add(label);
    form.add(tools);
    //Adding Form to the Application
    app.add(form);
}

//Init Application and start main loop.
app.run();