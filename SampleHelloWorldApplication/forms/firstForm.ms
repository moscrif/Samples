class FirstForm : Form
{
    function init()
    {
        super.init();

        this.add(new TitleBar({
            title    : "Step one"
        }));

        this.add(new Label({
            text    : "This is label!"
        }));
        // text fields
        this._nameBtn = new TextBox({
            hint : "name",
        });
        this.add(this._nameBtn);

        this._surnameBtn = new TextBox({
            hint : "surname",
        });
        this.add(this._surnameBtn);

        this._next = new Button({
            text    : "next"
        });
        this._next.onClick = function()
        {
            userName = this super._nameBtn.value;
            userSurname = this super._surnameBtn.value;
            app.push(new SecondForm());
        }
        this.add(this._next);
    }
}