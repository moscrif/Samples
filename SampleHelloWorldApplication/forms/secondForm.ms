class SecondForm : Form
{
    function init()
    {
        super.init();

        this.add(new TitleBar({
            title    : "Step two"
        }));

        this.add(new Label({
            text    : "name: " + userName
        }));

        this.add(new Label({
            text    : "sername: " + userSurname
        }));

        this._next = new Button({
            text    : "QUIT"
        });
        this._next.onClick = function()
        {
            app.quit();
        }
        this.add(this._next);
    }
}