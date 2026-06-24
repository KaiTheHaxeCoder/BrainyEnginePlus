package backend;

import haxe.Json;

typedef EditorData = 
{
    /**
        Set this to true if you want your state to be in an editor.
    **/
    var isEditor:Bool;
    var editorName:String;
}

/**
    Represents the data structure of state manifest files.
**/
typedef StateFile = 
{
    /**
        How the scripted state is made. If this field is set to `override`, 
    **/
    @:optional var mode:String;
    /**
        Field representing EditorData, to make your editor states appear in the Editor Menu.
    **/
    @:optional var editorData:EditorData;
}

class StateData
{
    /**
        How the scripted state is made. If this field is set to `override`, 
    **/
    public var mode:String = 'modify';

    /**
        Field representing EditorData, to make your editor states appear in the Editor Menu.
    **/
    public var editorData:EditorData;

    public function new(data:StateFile)
    {
        if (data.mode != null)
            mode = data.mode;

        if (data.editorData == null)
            data.editorData = {isEditor: false, editorName: ""};

        mode = mode.toLowerCase();
        editorData = data.editorData;
    }

    /**
        Loads a state manifest file by state name (e.g. `MainMenuState` fetches data from `states/MainMenuState.json` to be used in `MainMenuState`)
    **/
    public static function loadStateData(name:String):StateData
    {
        var path = '';

        #if MODS_ALLOWED
        var targetFile:String = name.toLowerCase() + '.json';
        for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'states/'))
        {
            if (FileSystem.exists(folder))
            {
                for (file in FileSystem.readDirectory(folder))
                {
                    if (file.toLowerCase() == targetFile)
                    {
                        path = folder + file;
                        break;
                    }
                }
            }
            if (path != '') break;
        }

        if (path == '')
        #end
            path = Paths.hx('states/$name', 'shared');

        var rawJson:String;
        
        try
        {
            rawJson = File.getContent(path);
        }
        catch (e)
        {
            trace('Failed to load state data: $path | ${e}');
            return new StateData({});
        }
        var data:StateFile = Json.parse(rawJson);
        return new StateData(data);
    }
}