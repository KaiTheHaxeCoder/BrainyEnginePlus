package states;

import flixel.util.FlxTimer;

class EntryState extends flixel.FlxState
{
    override public function create()
    {
        super.create();
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
        new FlxTimer().start(0.1, function (t:FlxTimer)
        {
            MusicBeatState.switchState(new states.TitleState());
        });
    }
}