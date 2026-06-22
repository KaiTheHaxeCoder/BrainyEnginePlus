package psychlua.events;

/**
    Base Class for Script Events, doesn't really do anything by itself.
**/
class ScriptEvent
{
    public function new() {}

    public function cancellable():Bool
        return true;

    public var cancelled(default, set):Bool = false;

    public function set_cancelled(v:Bool):Bool
    {
        if (!cancellable())
            v = false;

        cancelled = v;
        return v;
    }

    public function cancel()
    {
        if (cancellable())
        {
            cancelled = true;
        }
    }
}

class UpdateEvent extends ScriptEvent
{
    override public function cancellable() 
        return false;

    public var elapsed:Float;
}

class StepHitEvent extends ScriptEvent
{
    override public function cancellable()
        return false;

    public var curStep:Int;
    public var curBeat:Int;
    public var curSection:Int;

    public var curDecStep:Float;
    public var curDecBeat:Float;
}