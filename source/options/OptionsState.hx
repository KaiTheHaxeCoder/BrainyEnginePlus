package options;

import backend.ui.PsychUIEventHandler.PsychUIEvent;
import states.MainMenuState;
import options.*;
import options.objects.OptionSprite;

import options.Option;

class OptionsState extends MusicBeatState implements PsychUIEvent
{
    public static var onPlayState:Bool = false;
    public static var instance:OptionsState;

    public var bg:FlxSprite;

    public var box:PsychUIBox;

    override public function new()
    {
        instance = this;
        super();
    }

    override public function createPost()
    {
        super.createPost();

        FlxG.mouse.visible = true;

        bg = new FlxSprite(0, 0, Paths.image('menuDesat'));
        bg.color = 0x9AFFF5; 
        bg.screenCenter();

        add(bg);

        box = new PsychUIBox(0, 0, FlxG.width - 100, FlxG.height - 50, ["Gameplay", 'Graphics', 'Visuals', 'Misc']);
        box.canMove = false;
        box.canMinimize = false;
        box.screenCenter();

        add(box);

        createGameplayMenu();
        createGraphicsMenu();
        createVisualsMenu();
		createMiscMenu();
    }

    override public function update(elapsed:Float)
    {
        if (controls.BACK)
        {
            if (onPlayState)
                MusicBeatState.switchState(new PlayState());
            else
                MusicBeatState.switchState(new MainMenuState());
        }
        
        super.update(elapsed);
    }

    override function destroy()
    {
        ClientPrefs.saveSettings();
        super.destroy();
        FlxG.mouse.visible = false;
    }


    var downscroll:OptionSprite;
    var middlescroll:OptionSprite;
    var opponentNotes:OptionSprite;
    var ghostTapping:OptionSprite;
    var autoPause:OptionSprite;
    var noReset:OptionSprite;
    var guitarHeroSustains:OptionSprite;
    var hitsoundVolume:OptionSprite;
    var ratingOffset:OptionSprite;
    var sickWindow:OptionSprite;
    var goodWindow:OptionSprite;
    var badWindow:OptionSprite;
    var safeFrames:OptionSprite;

    function createGameplayMenu()
    {
        var tab = box.getTab('Gameplay').menu;

        var objX = 10;
        var objY = 10;
        var spacing = 45;

        downscroll = new OptionSprite(objX, objY, 'Downscroll', 'downScroll', 'bool', 'If checked, notes go Down instead of Up, simple enough.');
        tab.add(downscroll);
        objY += spacing;

        middlescroll = new OptionSprite(objX, objY, 'Middlescroll', 'middleScroll', 'bool', 'If checked, your notes get centered.');
        tab.add(middlescroll);
        objY += spacing;

        opponentNotes = new OptionSprite(objX, objY, 'Opponent Notes', 'opponentStrums', 'bool', 'If unchecked, opponent notes get hidden.');
        tab.add(opponentNotes);
        objY += spacing;

        ghostTapping = new OptionSprite(objX, objY, 'Ghost Tapping', 'ghostTapping', 'bool', "If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.");
        tab.add(ghostTapping);
        objY += spacing;

        autoPause = new OptionSprite(objX, objY, 'Auto Pause', 'autoPause', 'bool', "If checked, the game automatically pauses if the screen isn't on focus.");
        tab.add(autoPause);
        objY += spacing;

        noReset = new OptionSprite(objX, objY, 'Disable Reset Button', 'noReset', 'bool', "If checked, pressing Reset won't do anything.");
        tab.add(noReset);
        objY += spacing;

        guitarHeroSustains = new OptionSprite(objX, objY, 'Sustains as One Note', 'guitarHeroSustains', 'bool', "If checked, Hold Notes can't be pressed if you miss,\nand count as a single Hit/Miss.\nUncheck this if you prefer the old Input System.");
        tab.add(guitarHeroSustains);
        objY += spacing;

        hitsoundVolume = new OptionSprite(objX, objY, 'Hitsound Volume', 'hitsoundVolume', 'slider', 'Funny notes does "Tick!" when you hit them.', {min: 0, max: 1});
        tab.add(hitsoundVolume);
        objY += spacing;

        ratingOffset = new OptionSprite(objX, objY, 'Rating Offset', 'ratingOffset', 'int', 'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.', {min: -30, max: 30, step: 1, decimals: 0});
        tab.add(ratingOffset);
        objY += spacing;

        sickWindow = new OptionSprite(objX, objY, 'Sick! Hit Window', 'sickWindow', 'float', 'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.', {min: 15, max: 45, step: 0.1, decimals: 1});
        tab.add(sickWindow);
        objY += spacing;

        goodWindow = new OptionSprite(objX, objY, 'Good Hit Window', 'goodWindow', 'float', 'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.', {min: 15, max: 90, step: 0.1, decimals: 1});
        tab.add(goodWindow);
        objY += spacing;

        badWindow = new OptionSprite(objX, objY, 'Bad Hit Window', 'badWindow', 'float', 'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.', {min: 15, max: 135, step: 0.1, decimals: 1});
        tab.add(badWindow);
        objY += spacing;

        safeFrames = new OptionSprite(objX, objY, 'Safe Frames', 'safeFrames', 'float', 'Changes how many frames you have for\nhitting a note earlier or late.', {min: 0, max: 10, step: 1, decimals: 0});
        tab.add(safeFrames);

        objY += spacing;

        var controls = new PsychUIButton(objX, objY, 'Open Controls Menu', function() {
            box.active = false;
            openSubState(new ControlsSubState());
        }, 160);
        tab.add(controls);
    }

    var lowQuality:OptionSprite;
    var antiAliasing:OptionSprite;
    var shaders:OptionSprite;
    var cacheOnGPU:OptionSprite;
    var framerate:OptionSprite;

    function createGraphicsMenu()
    {
        var tab = box.getTab('Graphics').menu;
        var objX = 10;
        var objY = 10;
        var spacing = 45;

        lowQuality = new OptionSprite(objX, objY, 'Low Quality', 'lowQuality', 'bool', 'If checked, disables some background details,\ndecreases loading times and improves performance.');
        tab.add(lowQuality);
        objY += spacing;

        antiAliasing = new OptionSprite(objX, objY, 'Anti-Aliasing', 'antialiasing', 'bool', 'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.');
        tab.add(antiAliasing);
        objY += spacing;

        shaders = new OptionSprite(objX, objY, 'Shaders', 'shaders', 'bool', "If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.");
        tab.add(shaders);
        objY += spacing;

        cacheOnGPU = new OptionSprite(objX, objY, 'GPU Caching', 'cacheOnGPU', 'bool', "If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.");
        tab.add(cacheOnGPU);
        objY += spacing;

        #if !html5
        framerate = new OptionSprite(objX, objY, 'Framerate', 'framerate', 'int', "Pretty self explanatory, isn't it?", {min: 60, max: 240, step: 1, decimals: 0});
        tab.add(framerate);
        #end
    }

    var noteSkinOpt:OptionSprite;
    var splashSkinOpt:OptionSprite;
    var splashAlphaOpt:OptionSprite;
    var hideHud:OptionSprite;
    var timeBarTypeOpt:OptionSprite;
    var fluffText:OptionSprite;
    var cameraZoomOnBeat:OptionSprite;
    var scoreTextZoom:OptionSprite;
    var healthBarOpacity:OptionSprite;
    var comboStacking:OptionSprite;

    function createVisualsMenu()
    {
        var tab = box.getTab('Visuals').menu;
        var objX = 10;
        var objY = 10;
        var spacing = 40;

        var noteSkinsArray:Array<String> = Mods.mergeAllTextsNamed('images/noteSkins/list.txt');
        if (!noteSkinsArray.contains(ClientPrefs.data.noteSkin))
            ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin;
        noteSkinsArray.insert(0, ClientPrefs.defaultData.noteSkin);

        noteSkinOpt = new OptionSprite(objX, objY, 'Note Skins:', 'noteSkin', 'string', "Select your prefered Note skin.", {options: noteSkinsArray});
        objY += spacing;

        var noteSplashesArray:Array<String> = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt');
        if (!noteSplashesArray.contains(ClientPrefs.data.splashSkin))
            ClientPrefs.data.splashSkin = ClientPrefs.defaultData.splashSkin;
        noteSplashesArray.insert(0, ClientPrefs.defaultData.splashSkin);

        splashSkinOpt = new OptionSprite(objX, objY, 'Note Splashes:', 'splashSkin', 'string', "Select your prefered Note Splash variation.", {options: noteSplashesArray});
        objY += spacing;

        splashAlphaOpt = new OptionSprite(objX, objY, 'Note Splash Opacity', 'splashAlpha', 'percent', 'How much transparent should the Note Splashes be.', {min: 0.0, max: 1.0, step: 0.1, decimals: 1});
        tab.add(splashAlphaOpt);
        objY += spacing;

        hideHud = new OptionSprite(objX, objY, 'Hide HUD', 'hideHud', 'bool', 'If checked, hides most HUD elements.');
        tab.add(hideHud);
        objY += spacing;

        timeBarTypeOpt = new OptionSprite(objX, objY, 'Time Bar:', 'timeBarType', 'string', "What should the Time Bar display?", {options: ['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']});
        objY += spacing;

        fluffText = new OptionSprite(objX, objY, 'Flashing Lights', 'flashing', 'bool', "Uncheck this if you're sensitive to flashing lights!");
        tab.add(fluffText);
        objY += spacing;

        cameraZoomOnBeat = new OptionSprite(objX, objY, 'Camera Zooms', 'camZooms', 'bool', "If unchecked, the camera won't zoom in on a beat hit.");
        tab.add(cameraZoomOnBeat);
        objY += spacing;

        scoreTextZoom = new OptionSprite(objX, objY, 'Score Text Grow on Hit', 'scoreZoom', 'bool', "If unchecked, disables the Score text growing\neverytime you hit a note.");
        tab.add(scoreTextZoom);
        objY += spacing;

        healthBarOpacity = new OptionSprite(objX, objY, 'Health Bar Opacity', 'healthBarAlpha', 'percent', 'How much transparent should the health bar and icons be.', {min: 0.0, max: 1.0, step: 0.1, decimals: 1});
        tab.add(healthBarOpacity);
        objY += spacing;

        comboStacking = new OptionSprite(objX, objY, 'Combo Stacking', 'comboStacking', 'bool', "If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read");
        tab.add(comboStacking);

        objY += spacing;

        var noteColors = new PsychUIButton(objX, objY, 'Open Note Colors Menu', function() {
            box.active = false;
            openSubState(new NotesColorSubState());
        }, 160);
        tab.add(noteColors);

        objY += spacing;

        var offsetMenu = new PsychUIButton(objX, objY, 'Open Offset Menu', function() {
            MusicBeatState.switchState(new NoteOffsetState());
        }, 160);
        tab.add(offsetMenu);

		tab.add(timeBarTypeOpt);
        tab.add(splashSkinOpt);
        tab.add(noteSkinOpt);
    }

	var devMode:OptionSprite;
	var fpsCounter:OptionSprite;
    var pauseMusic:OptionSprite;
    var checkUpdatesOpt:OptionSprite;
    var discordRpcOpt:OptionSprite;

	function createMiscMenu()
	{
		var tab = box.getTab('Misc').menu;

        var objX = 10;
        var objY = 10;
        var spacing = 45;

        devMode = new OptionSprite(objX, objY, 'Developer Mode', 'developerMode', 'bool', 'If checked, you have access to certain developer features used for making mods.');
        tab.add(devMode);
        objY += spacing;

		#if !mobile
        fpsCounter = new OptionSprite(objX, objY, 'FPS Counter', 'showFPS', 'bool', 'If unchecked, hides FPS Counter.');
        tab.add(fpsCounter);
        objY += spacing;
        #end

        pauseMusic = new OptionSprite(objX, objY, 'Pause Music:', 'pauseMusic', 'string', "What song do you prefer for the Pause Screen?", {options: ['None', 'Tea Time', 'Breakfast', 'Breakfast (Pico)']});
        objY += spacing;

        #if CHECK_FOR_UPDATES
        checkUpdatesOpt = new OptionSprite(objX, objY, 'Check for Updates', 'checkForUpdates', 'bool', 'Turn this on to check for updates when you start the game.');
        tab.add(checkUpdatesOpt);
        objY += spacing;
        #end

        #if DISCORD_ALLOWED
        discordRpcOpt = new OptionSprite(objX, objY, 'Discord Rich Presence', 'discordRPC', 'bool', "Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord");
        tab.add(discordRpcOpt);
        objY += spacing;
        #end

        discordRpcOpt = new OptionSprite(objX, objY, 'Show Album in Freeplay', 'showAlbum', 'bool', "If checked, shows albums in Freeplay.");
        tab.add(discordRpcOpt);
        objY += spacing;
		
		tab.add(pauseMusic);
	}

    override public function UIEvent(id:String, sender:Dynamic) 
    {
        super.UIEvent(id, sender);

        switch (id)
        {
            case PsychUISlider.CHANGE_EVENT:
                if (sender == hitsoundVolume)
                {
                    FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
                }

			case PsychUICheckBox.CLICK_EVENT:
				if (sender == fpsCounter)
					if(Main.fpsVar != null)
						Main.fpsVar.visible = ClientPrefs.data.showFPS;
        }

		ClientPrefs.saveSettings();
    }
}