package backend.macros;

@:dox(hide)
class Macros
{
    public static macro function print(msg:String)
    {
        Sys.println(msg);
        return macro Sys.println(msg);
    }
}