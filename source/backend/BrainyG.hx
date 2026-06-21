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
}