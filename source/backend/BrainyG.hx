package backend;

class BrainyG
{
    public static function screenCenter(obj:FlxSprite, axis = 'xy')
    {
        switch (axis.toLowerCase().trim())
        {
            case 'x':
                obj.screenCenter(X);
            case 'y':
                obj.screenCenter(Y);
            default:
                obj.screenCenter();
            
        }
    }

    public static function centerOnTarget(obj:FlxSprite, on:FlxSprite)
    {
        obj.x = on.x + (on.width - obj.width) / 2;
        obj.y = on.y + (on.height - obj.height) / 2;
    }
}