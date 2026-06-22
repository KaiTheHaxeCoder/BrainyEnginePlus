package backend;

import flixel.FlxState;
import backend.PsychCamera;

import psychlua.*;
import psychlua.helpers.*;
import psychlua.events.ScriptEvent;

class MusicBeatState extends FlxState implements psychlua.interfaces.IScriptable
{
	public var scripts:Map<String, HScript> = new Map();
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	public var controls(get, never):Controls;
	private function get_controls()
	{
		return Controls.instance;
	}

	var _psychCameraInitialized:Bool = false;

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static function getVariables()
		return getState().variables;


	public var script:HScript;
	public var scriptName:String;

	#if HSCRIPT_ALLOWED
	public function reloadScripts()
	{
		trace(scriptName);
		scripts.set(scriptName, Scripting.loadScript(scriptName, 'states'));
		script = scripts.get(scriptName);
	}

	#end
	override public function new(?nameOver:String)
	{
		super();
		#if HSCRIPT_ALLOWED
		if (nameOver == null)
		{
			var fullName = Type.getClassName(Type.getClass(this));
			scriptName = fullName.split(".").pop();
		}
		else
			scriptName = nameOver;
		reloadScripts();
		#end
	}

	public function call(func, ?args):Dynamic
	{
		if (script != null)
			if (script.exists(func)) 
				return script.call(func, args);

		return null;
	}

	override function create() 
	{
		if (script != null)
			script.execute();

		trace((script == null));

		call('onCreatePre');
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		#if MODS_ALLOWED Mods.updatedOnState = false; #end

		if(!_psychCameraInitialized) initPsychCamera();

		super.create();
		call('onCreate');

		if(!skip) {
			openSubState(new CustomFadeTransition(0.5, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;

		call('onCreatePost');
	}

	public function initPsychCamera():PsychCamera
	{
		var camera = new PsychCamera();
		FlxG.cameras.reset(camera);
		FlxG.cameras.setDefaultDrawTarget(camera, true);
		_psychCameraInitialized = true;
		//trace('initialized psych camera ' + Sys.cpuTime());
		return camera;
	}

	public static var timePassedOnState:Float = 0;
	var updateEvent:UpdateEvent = new UpdateEvent();
	override function update(elapsed:Float)
	{
		updateEvent.elapsed = elapsed;
		call('onUpdate', [updateEvent]);
		//everyStep();
		var oldStep:Int = curStep;
		timePassedOnState += elapsed;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
		
		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

		super.update(elapsed);

		call('onUpdatePost', [updateEvent]);
	}

	override public function destroy()
	{
		var destroyEvent:ScriptEvent = new ScriptEvent();
		call('onDestroy', [destroyEvent]);
		if (destroyEvent.cancelled == false)
			super.destroy();
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState = null) {
		if(nextState == null) nextState = FlxG.state;
		if(nextState == FlxG.state)
		{
			resetState();
			return;
		}

		if(FlxTransitionableState.skipNextTransIn) FlxG.switchState(nextState);
		else startTransition(nextState);
		FlxTransitionableState.skipNextTransIn = false;
	}

	public static function resetState() {
		if(FlxTransitionableState.skipNextTransIn) FlxG.resetState();
		else startTransition();
		FlxTransitionableState.skipNextTransIn = false;
	}

	// Custom made Trans in
	public static function startTransition(nextState:FlxState = null)
	{
		if(nextState == null)
			nextState = FlxG.state;

		FlxG.state.openSubState(new CustomFadeTransition(0.5, false));
		if(nextState == FlxG.state)
			CustomFadeTransition.finishCallback = function() FlxG.resetState();
		else
			CustomFadeTransition.finishCallback = function() FlxG.switchState(nextState);
	}

	public static function getState():MusicBeatState {
		return cast (FlxG.state, MusicBeatState);
	}

	var stepHitEvent:StepHitEvent = new StepHitEvent();

	public function stepHit():Void
	{
		stepHitEvent.curStep = curStep;
		stepHitEvent.curBeat = curBeat;
		stepHitEvent.curSection = curSection;
		stepHitEvent.curDecStep = curDecStep;
		stepHitEvent.curDecBeat = curDecBeat;
		call('onStepHit', [stepHitEvent]);
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];
	public function beatHit():Void
	{
		call('onBeatHit', [stepHitEvent]);
		//trace('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void
	{
		call('onSectionHit', [stepHitEvent]);
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});
	}

	function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if(stage != null && stage.exists && stage.active)
				func(stage);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}

class CustomState
{
	public static function switchState(state:String):MusicBeatState
	{
		var nextState = new MusicBeatState(state);
		MusicBeatState.switchState(nextState);
		return MusicBeatState.getState();
	}
}