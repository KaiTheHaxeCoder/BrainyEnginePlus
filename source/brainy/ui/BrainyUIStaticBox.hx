package brainy.ui;

class BrainyUIStaticBox extends brainy.ui.BrainyUIBox
{
    public function new(x:Float, y:Float, width:Int, height:Int, tabs:Array<String> = null, canMinimize:Bool = false)
    {
        super(x, y, width, height, tabs);

        this.canMinimize = canMinimize;
        canMove = false;
    }
}
