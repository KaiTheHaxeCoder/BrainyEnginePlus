package objects;

typedef StrumPos =
{
    var x:Int;
    var y:Int;
}

typedef CharacterData =
{
    var char:String;
    @:optional var isPlayer:Bool;
    @:optional var x:Float;
    @:optional var y:Float;
    @:optional var flipX:Bool;
}

class Strum extends flixel.FlxBasic
{
    public var character:Character;
    public var strumNotes:StrumNote;
    public var isCpuControlled:Bool = true;

    public var keyCount:Int = 4;

    public var strumX = 0;
    public var strumY = 0;

    public static var characters:Map<String, Character> = new Map();
    
    inline public function add(spr:FlxSprite)
        MusicBeatState.getState().add(spr);

    inline public function insert(index:Int, spr:FlxSprite)
        MusicBeatState.getState().insert(index, spr);

    public override function new(char:CharacterData, strumPos:StrumPos, isCpuControlled = true, ?keyCount:Int)
    {
        this.isCpuControlled = isCpuControlled;
        if (keyCount != null)
            keyCount = this.keyCount;

        if (char?.x == null) char.x = 0;
        if (char?.y == null) char.y = 0;
        if (char?.isPlayer == null) char.isPlayer = false;

        character = new Character(char.x, char.y, char.char, char.isPlayer);
        characters.set(char.char, character);

        if (char?.flipX != null) character.flipX = char.flipX;

        this.strumX = strumPos.x;
        this.strumY = strumPos.y;

        super();

        create();
    }

    function create()
    {
        add(character);
    }
}