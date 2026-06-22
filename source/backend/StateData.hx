package backend;

import haxe.Json;

typedef StateFile = 
{
    @:optional var mode:String;
}

class StateData
{
    public var mode:String = 'modify';

    public function new(data:StateFile)
    {
        if (data.mode != null)
            mode = data.mode;

        mode = mode.toLowerCase();
    }

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
            trace('Failed to load stage data: $path | ${e}');
            return new StateData({});
        }
        var data = cast(Json.parse(rawJson));
        return new StateData(data);
    }
}