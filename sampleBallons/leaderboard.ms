class Leaderboard
{
    // maximum reports in the table
    const maxRecords = 10;

    function this()
    {
        // open databse file
        this._database = Database.open("app://leaderboard.db");
    }

    function insert(score)
    {
        // current time and date
        var d = new Date();
        // insert row
        this._database.exec("INSERT INTO leaderboard VALUES (null, " + score + ", '" + d.hour + ":" + d.minute + " " + d.day + "." + d.month + "." + d.year + "');");
        // number of rows
        var data = this._database.exec("SELECT Count(*) FROM leaderboard");
        // if there are more rows as it is required
        if (data["Count(*)"] > maxRecords) {
            // delete row with the lowest score
            this._database.exec("DELETE from leaderboard WHERE id = (SELECT id FROM leaderboard ORDER BY score ASC LIMIT 1);");
        }
    }

    // Returns object constructed from current row as { field1: value1, field2: value2, etc. }
    function Dataset.rowAsObject()
    {
        var names = this.names;
        if (!names) {
            names = [];
            for (var n = 0; n < this.length; ++n)
                names.push(symbol(this.name(n)));
            this.names = names;
        }
        var obj = {}; var n = 0;
        for (var v in this)
            obj[names[n++]] = v;
        return obj;
    }

    function getTable()
    {
        var table = new Array();
        // select data from the table
        var data = this._database.exec("SELECT * from leaderboard ORDER BY score DESC;");
    
        // if there are no data -> return
        if (!data)
            return;
    
        // push one row to the table
        do {
            table.push(data.rowAsObject());
        } while (data.next());
    
        return table;
    }
}