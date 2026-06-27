package funkin;

class FunkinSpriteGroup extends FlxSpriteGroup
{
    public var _initialized:Bool =
    public function new(X:Float = 0, Y:Float = 0, MaxSize:Float = 0)
    {
        super(X, Y, MaxSize);
        create();
    }

    function create() {}

}