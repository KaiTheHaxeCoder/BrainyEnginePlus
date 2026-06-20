package psychlua.helpers;

import psychlua.*;
#if MODS_ALLOWED
import sys.FileSystem;
#end

class Scripting
{
    inline static public function loadScript(name:String, parentFolder = 'scripts'):HScript
    {
        var hscript:HScript = null;
        var path = '';

        #if MODS_ALLOWED
        var targetFile:String = name.toLowerCase() + '.hx';
        for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), '$parentFolder/'))
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
            path = Paths.hx('$parentFolder/$name', 'shared');
    
        trace(path);

        try 
        {
            hscript = new HScript(null, path);
        } 
        catch(e)
        {
            trace('Script at $parentFolder/$name.hx not found.');
        }
        return hscript;
    }
}