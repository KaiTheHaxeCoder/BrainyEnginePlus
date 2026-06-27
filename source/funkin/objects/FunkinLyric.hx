package funkin.objects;

using backend.BrainyG;

class FunkinLyric extends funkin.FunkinSpriteGroup
{
    var textObj:FlxText;
    var box:FlxSprite;

    private var temp_text:String;
    public var text(default, set):String;

    public function set_text(v:String):String
    {
        if (textObj != null)
        {
            textObj.text = v;
            if (box != null)
            {
                box.scale.set(textObj.width + 2, textObj.height + 2);
                box.updateHitbox();
            }
        }

        screenCenter();

        return text = v;
    }

    override public function new(text:String)
    {
        this.temp_text = text;
        super();
    }

    override function create()
    {
        textObj = new FlxText();
        textObj.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER);
        text = temp_text;

        box = new FlxSprite();
        box.makeGraphic(1, 1, FlxColor.BLACK);
        box.scale.set(textObj.width + 2, textObj.height + 2);
        box.alpha = 0.5;
        box.updateHitbox();

        box.centerOnTarget(textObj);

        add(box);
        add(textObj);
    }
}