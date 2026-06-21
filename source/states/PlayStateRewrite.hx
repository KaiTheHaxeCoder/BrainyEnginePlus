package states;

import objects.Strum;
import states.stages.*;
import backend.Song;

typedef PlayStateParameters = 
{
    var songName:String;
    var difficulty:Int;
    @:optional var variation:String;
}

@:keep
class PlayStateRewrite extends MusicBeatState
{
	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 0.999], //From 90% to 99%
		['Perfect!!', 1] //100%
	];

    public var playerStrum:Strum;

    public static var instance:Dynamic;
    public static var SONG:Dynamic;

    public var inst:FlxSound;
	public var vocals:FlxSound;
	public var opponentVocals:FlxSound;

    override public function new(params:PlayStateParameters)
    {
        var formattedSong = Paths.formatToSongPath(params.songName);
        SONG = Song.loadFromJson(formattedSong, formattedSong);

        super();

        instance = this;
    }

    public function switchStage(stage:String)
    {
        switch (stage)
		{
			case 'stage': new StageWeek1(); 			//Week 1
			case 'spooky': new Spooky();				//Week 2
			case 'philly': new Philly();				//Week 3
			case 'limo': new Limo();					//Week 4
			case 'mall': new Mall();					//Week 5 - Cocoa, Eggnog
			case 'mallEvil': new MallEvil();			//Week 5 - Winter Horrorland
			case 'school': new School();				//Week 6 - Senpai, Roses
			case 'schoolEvil': new SchoolEvil();		//Week 6 - Thorns
			case 'tank': new Tank();					//Week 7 - Ugh, Guns, Stress
			case 'phillyStreets': new PhillyStreets(); 	//Weekend 1 - Darnell, Lit Up, 2Hot
			case 'phillyBlazin': new PhillyBlazin();	//Weekend 1 - Blazin
		}
    }

    override public function create()
    {
        Strum.characters = new Map();
        super.create();
        //switchStage('stage');
        playerStrum = new Strum({char: "bf", isPlayer: true, flipX: true}, {x: 0, y: 0}, false);
        opponentStrum = new Strum({char: "dad", isPlayer: false}, {x: 0, y: 0}, true);

        if(FlxG.sound.music != null)
			FlxG.sound.music.stop();

        vocals = new FlxSound();
		opponentVocals = new FlxSound();
		try
		{
			if (SONG.needsVoices)
			{
				vocals.loadEmbedded(Paths.voices(SONG.song));
				
			}
		}
		catch (e:Dynamic) {}



        inst = new FlxSound();
		try
		{
			inst.loadEmbedded(Paths.inst(SONG.song));
		}
		catch (e:Dynamic) {}
		FlxG.sound.list.add(inst);

        @:privateAccess
        FlxG.sound.playMusic(inst._sound, 1, false);

        Conductor.mapBPMChanges(SONG);
		Conductor.bpm = SONG.bpm;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        Conductor.songPosition = FlxG.sound.music.time;
    }

    override public function beatHit()
    {
        super.beatHit();

        for (char in Strum.characters)
            char.dance();
    }
}