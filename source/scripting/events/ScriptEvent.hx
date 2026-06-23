package scripting.events;

/**
    Base Class for Script Events, doesn't really do anything by itself, but can be canceled.
**/
class ScriptEvent
{
    @:dox(hide)
    public function new() {}

    /**
        Whether or not an event can be canceled or not.
    **/
    public function cancellable():Bool
        return true;

     /**
        Whether or not the current event is canceled.
    **/
    public var cancelled(default, set):Bool = false;

    @:dox(hide)
    public function set_cancelled(v:Bool):Bool
    {
        if (!cancellable())
            v = false;

        cancelled = v;
        return v;
    }

     /**
        Cancels current function (if cancellable).
    **/
    public function cancel()
    {
        if (cancellable())
        {
            cancelled = true;
        }
    }
}

/**
    Script Event used for onUpdate and similar callbacks.
**/
class UpdateEvent extends ScriptEvent
{
    override public function cancellable() 
        return false;

    /**
        Time since last frame.
    **/
    public var elapsed:Float;
}

/**
    Script Event used for onStepHit and similar callbacks
**/
class StepHitEvent extends ScriptEvent
{
    override public function cancellable()
        return false;

    /**
        Current step (in relation is FlxG.sound.music)
    **/
    public var curStep:Int;
    /**
        Current beat (in relation is FlxG.sound.music)
    **/
    public var curBeat:Int;
    /**
        Current measure (in relation is FlxG.sound.music)
    **/
    public var curSection:Int;

    public var curDecStep:Float;
    public var curDecBeat:Float;
}