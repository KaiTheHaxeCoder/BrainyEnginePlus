package objects;

import funkin.FunkinSpriteGroup;

#if funkin.vis
import funkin.vis.dsp.SpectralAnalyzer;

class Visualizer extends FunkinSpriteGroup
{
    var analyzer:SpectralAnalyzer;

    public var snd(default, set):FlxSound;
	function set_snd(changed:FlxSound)
	{
		snd = changed;
		initAnalyzer();
		return snd;
	}

    override public function new(snd:FlxSound, X:Float = 0, Y:Float = 0)
    {
        this.snd = snd;
        super(X, Y);
    }

    override function create()
    {

    }

    public function initAnalyzer()
	{
		@:privateAccess
		analyzer = new SpectralAnalyzer(snd._channel.__audioSource, 7, 0.1, 40);
	
		#if desktop
		// On desktop it uses FFT stuff that isn't as optimized as the direct browser stuff we use on HTML5
		// So we want to manually change it!
		analyzer.fftN = 256;
		#end
	}

    var levels:Array<Bar>;
	var levelMax:Int = 0;
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(analyzer == null) return;

		levels = analyzer.getLevels(levels);
		
        
	}
}
#end