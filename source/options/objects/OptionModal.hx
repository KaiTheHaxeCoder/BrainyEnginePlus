package options.objects;

using backend.BrainyG;

class OptionModal extends FlxSpriteGroup
{
    var text:FlxText;
    var box:FlxSprite;

    public var label(default, set):String;
    public function set_label(v:String):String
    {
        if (text != null)
        {
            text.text = v;
            box.scale.set(text.width + 10, text.height + 10);
            box.updateHitbox();
            box.centerOnTarget(text);
        }
        return v;
    }

    override public function new(x:Float, y:Float, label:String)
    {
        this.label = label;
        super(x, y);
        create();
    }

    public function create()
    {
        text = new FlxText(0, 0, FlxG.width - FlxG.mouse.x, label);
        box = new FlxSprite();
        box.makeGraphic(1, 1, FlxColor.BLACK);
        box.scale.set(text.width + 5, text.height + 5);
        box.alpha = 0.5;
        box.updateHitbox();
        box.centerOnTarget(text);

        add(box);
        add(text);
    }
}