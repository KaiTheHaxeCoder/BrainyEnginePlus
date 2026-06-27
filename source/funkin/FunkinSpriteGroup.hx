package funkin;

class FunkinSpriteGroup extends FlxSpriteGroup
{
    public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0)
    {
        super(X, Y, MaxSize);
        create();
    }

    function create() {}

}